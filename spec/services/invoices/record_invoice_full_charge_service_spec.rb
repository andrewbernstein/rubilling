require "rails_helper"

describe Invoices::RecordInvoiceFullChargeService do
  let(:invoice) { create(:invoice, :with_line_item_with_base_adjustment) }
  let(:payment_method) { create(:payment_method) }
  let(:amount_in_cents) { 1000 }
  let(:options) { { expect_no_taxes: true } }
  let(:is_invoice_chargeable_service_double) { double }
  let(:is_invoice_chargeable_service_result) { { errors: [], chargeable?: true } }
  let(:result) do
    described_class.new(
      invoice: invoice,
      payment_method: payment_method,
      amount_in_cents: amount_in_cents,
      options: options
    ).call
  end

  before do
    allow(Invoices::IsInvoiceChargeableService).to receive(:new).and_return(
      is_invoice_chargeable_service_double
    )
    allow(is_invoice_chargeable_service_double).to receive(:call).and_return(
      is_invoice_chargeable_service_result
    )
  end

  describe "#call" do
    context "validation" do
      it "calls Invoices::IsInvoiceChargeableService" do
        result
        expect(Invoices::IsInvoiceChargeableService).to have_received(:new)
        expect(is_invoice_chargeable_service_double).to have_received(:call)
      end

      context "when an invoice is not chargeable" do
        let(:is_invoice_chargeable_service_result) { { errors: [ "totally a real error" ], chargeable?: false } }

        it "returns the error" do
          expect(result).to eq({ errors: [ "totally a real error" ], success: false })
        end

        it "does not record a charge" do
          # does not create a transaction
          expect(Transaction.count).to eq(0)
          # does not create an applied transaction
          expect(AppliedTransaction.count).to eq(0)
          # does not create a payment adjustment
          expect(invoice.adjustments.count).to eq(1)
        end

        it "creates a validation failed Log" do
          result
          expect(Log.count).to eq(1)
          log = Log.first
          expect(log.action).to eq('Invoices::RecordInvoiceFullChargeService')
          expect(log.status).to eq('failed_validation')
        end
      end

      context "when a non-full charge is passed in" do
        context "overpayment" do
          let(:amount_in_cents) { 1100 }

          it "returns an error" do
            expect(result).to eq({ errors: [ "amount in cents does not match invoice total" ], success: false })
          end

          it "does not record a charge" do
            # does not create a transaction
            expect(Transaction.count).to eq(0)
            # does not create an applied transaction
            expect(AppliedTransaction.count).to eq(0)
            # does not create a payment adjustment
            expect(invoice.adjustments.count).to eq(1)
          end

          it "creates a validation failed Log" do
            result
            expect(Log.count).to eq(1)
            log = Log.first
            expect(log.action).to eq('Invoices::RecordInvoiceFullChargeService')
            expect(log.status).to eq('failed_validation')
          end
        end

        context "underpayment" do
          let(:amount_in_cents) { 900 }

          it "returns an error" do
            expect(result).to eq({ errors: [ "amount in cents does not match invoice total" ], success: false })
          end

          it "does not record a charge" do
            # does not create a transaction
            expect(Transaction.count).to eq(0)
            # does not create an applied transaction
            expect(AppliedTransaction.count).to eq(0)
            # does not create a payment adjustment
            expect(invoice.adjustments.count).to eq(1)
          end

          it "creates a validation failed Log" do
            result
            expect(Log.count).to eq(1)
            log = Log.first
            expect(log.action).to eq('Invoices::RecordInvoiceFullChargeService')
            expect(log.status).to eq('failed_validation')
          end
        end
      end
    end

    context "recording charges" do
      context "with one line item" do
        it "returns success" do
          expect(result).to eq({ errors: [], success: true })
        end

        it "creates a Transaction" do
          expect(Transaction.count).to eq(0)
          result
          expect(Transaction.count).to eq(1)
          transaction = Transaction.first
          expect(transaction.payment_method).to eq(payment_method)
          expect(transaction.amount_in_cents).to eq(amount_in_cents)
        end

        it "creates an AppliedTransaction" do
          expect(AppliedTransaction.count).to eq(0)
          result
          expect(AppliedTransaction.count).to eq(1)
          applied_transaction = AppliedTransaction.first
          expect(applied_transaction.payment_transaction).to eq(Transaction.first)
          expect(applied_transaction.amount_in_cents).to eq(amount_in_cents)
          expect(applied_transaction.invoice).to eq(invoice)
        end

        it "creates a Payment Adjustment" do
          # without referencing invoice, the base adjustment isn't created
          invoice
          expect(Adjustment.count).to eq(1)
          result
          expect(Adjustment.count).to eq(2)
          payment_adjustment = Adjustment.last
          expect(payment_adjustment.invoice).to eq(invoice)
          expect(payment_adjustment.line_item).to eq(invoice.line_items.first)
          expect(payment_adjustment.amount_in_cents).to eq(-1000)
          expect(invoice.total).to eq(0)
        end

        it "creates a successful Log" do
          result
          expect(Log.count).to eq(3) # calls to CreatePaymentAdjustmentService and CreateAdjustmentService
          log = Log.first
          expect(log.action).to eq('Invoices::RecordInvoiceFullChargeService')
          expect(log.status).to eq('successful')
        end
      end

      context "with two line items" do
        let(:line_item_2) { create(:line_item, :with_base_adjustment, invoice: invoice) }
        let(:amount_in_cents) { 2000 }

        before do
          invoice.line_items << line_item_2
          invoice.adjustments << line_item_2.base_adjustment
        end

        it "returns success" do
          expect(result).to eq({ errors: [], success: true })
        end

        it "creates a Transaction" do
          expect(Transaction.count).to eq(0)
          result
          expect(Transaction.count).to eq(1)
          transaction = Transaction.first
          expect(transaction.payment_method).to eq(payment_method)
          expect(transaction.amount_in_cents).to eq(amount_in_cents)
        end

        it "creates an AppliedTransaction" do
          expect(AppliedTransaction.count).to eq(0)
          result
          expect(AppliedTransaction.count).to eq(1)
          applied_transaction = AppliedTransaction.first
          expect(applied_transaction.payment_transaction).to eq(Transaction.first)
          expect(applied_transaction.amount_in_cents).to eq(amount_in_cents)
          expect(applied_transaction.invoice).to eq(invoice)
        end

        it "creates two Payment Adjustments" do
          expect(Adjustment.count).to eq(2)
          result
          expect(Adjustment.count).to eq(4)
          payment_adjustment = Adjustment.third
          expect(payment_adjustment.invoice).to eq(invoice)
          expect(payment_adjustment.line_item).to eq(invoice.line_items.first)
          expect(payment_adjustment.amount_in_cents).to eq(-1000)
          payment_adjustment2 = Adjustment.last
          expect(payment_adjustment2.invoice).to eq(invoice)
          expect(payment_adjustment2.line_item).to eq(line_item_2)
          expect(payment_adjustment2.amount_in_cents).to eq(-1000)
          expect(invoice.total).to eq(0)
        end

        it "creates a successful Log" do
          result
          expect(Log.count).to eq(5) # doubled calls to CreatePaymentAdjustmentService and CreateAdjustmentService
          log = Log.first
          expect(log.action).to eq('Invoices::RecordInvoiceFullChargeService')
          expect(log.status).to eq('successful')
        end
      end
    end
  end
end
