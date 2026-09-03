require "rails_helper"

describe Invoices::IsInvoiceChargeableService do
  let(:invoice) { create(:invoice, :with_line_item_with_base_adjustment) }
  let(:expect_no_taxes) { false }
  let(:result) do
    described_class.new(
      invoice: invoice,
      expect_no_taxes: expect_no_taxes
    ).call
  end

  describe "#call" do
    context "with no line items" do
      let(:invoice) { create(:invoice) }

      it "is not chargeable" do
        expect(result[:chargeable?]).to be false
      end

      it "retuns an error for no line items" do
        expect(result[:errors]).to include("no line items")
      end

      it "sets the log for the service call to validation failed" do
        result
        expect(Log.count).to eq(1)
        log = Log.first
        expect(log.action).to eq("Invoices::IsInvoiceChargeableService")
        expect(log.status).to eq("failed_validation")
      end
    end

    context "with no taxes" do
      it "is not chargeable" do
        expect(result[:chargeable?]).to be false
      end

      it "retuns an error for no line items" do
        expect(result[:errors]).to include("no taxes")
      end

      it "sets the log for the service call to validation failed" do
        result
        expect(Log.count).to eq(1)
        log = Log.first
        expect(log.action).to eq("Invoices::IsInvoiceChargeableService")
        expect(log.status).to eq("failed_validation")
      end

      context "if you expect no taxes" do
        let(:expect_no_taxes) { true }

        it "is not chargeable" do
          expect(result[:chargeable?]).to be true
        end

        it "retuns an error for no taxes" do
          expect(result[:errors]).not_to include("no taxes")
        end

        it "sets the log for the service call to successful" do
          result
          expect(Log.count).to eq(1)
          log = Log.first
          expect(log.action).to eq("Invoices::IsInvoiceChargeableService")
          expect(log.status).to eq("successful")
        end
      end
    end

    context "with taxes" do
      let(:tax_adjustment) { create(:tax_adjustment, invoice: invoice, line_item: invoice.line_items.first) }

      before do
        invoice.adjustments << tax_adjustment
        invoice.line_items.first.adjustments << tax_adjustment
      end

      it "is chargeable" do
        expect(result[:chargeable?]).to be true
      end

      it "has no errors" do
        expect(result[:errors]).to eq([])
      end

      it "sets the log for the service call to successful" do
        result
        expect(Log.count).to eq(1)
        log = Log.first
        expect(log.action).to eq("Invoices::IsInvoiceChargeableService")
        expect(log.status).to eq("successful")
      end

      context "if you expect no taxes" do
        let(:expect_no_taxes) { true }

        it "is not chargeable" do
          expect(result[:chargeable?]).to be false
        end

        it "retuns an error for has taxes" do
          expect(result[:errors]).to include("has taxes")
        end

        it "sets the log for the service call to validation failed" do
          result
          expect(Log.count).to eq(1)
          log = Log.first
          expect(log.action).to eq("Invoices::IsInvoiceChargeableService")
          expect(log.status).to eq("failed_validation")
        end
      end
    end

    context "already paid" do
      let(:payment_adjustment) { create(:payment_adjustment, invoice: invoice, line_item: invoice.line_items.first) }
      let(:tax_adjustment) { create(:tax_adjustment, invoice: invoice, line_item: invoice.line_items.first) }

      before do
        invoice.adjustments << payment_adjustment
        invoice.line_items.first.adjustments << payment_adjustment
        invoice.adjustments << tax_adjustment
        invoice.line_items.first.adjustments << tax_adjustment
      end

      it "is not chargeable" do
        expect(result[:chargeable?]).to be false
      end

      it "retuns an error for already paid" do
        expect(result[:errors]).to include("already paid")
      end

      it "sets the log for the service call to validation failed" do
        result
        expect(Log.count).to eq(1)
        log = Log.first
        expect(log.action).to eq("Invoices::IsInvoiceChargeableService")
        expect(log.status).to eq("failed_validation")
      end
    end
  end
end
