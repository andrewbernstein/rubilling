require "rails_helper"

# == Schema Information
#
# Table name: invoices
#
#  id                :bigint           not null, primary key
#  shortcode         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  external_id       :string
#  parent_invoice_id :bigint
#  payee_id          :bigint
#
# Indexes
#
#  index_invoices_on_shortcode  (shortcode) UNIQUE
#
describe Invoice do
  describe "#generate_shortcode" do
    context "shortcode invalid characters" do
      [ "b", "g", "l", "o" ].each do |char|
        it "does not contain #{char}" do
          10.times do
            invoice = Invoice.new
            invoice.save!
            expect(invoice.shortcode.index(char)).to be_nil
          end
        end
      end
    end
  end

  describe "#total, #paid?, and #overpaid?" do
    let(:invoice) { create(:invoice) }
    let(:line_item1) { create(:line_item, invoice: invoice) }
    let(:line_item2) { create(:line_item, invoice: invoice) }
    let(:base_adjustment1) { create(:base_adjustment, invoice: invoice, line_item: line_item1, amount_in_cents: 1000) }
    let(:base_adjustment2) { create(:base_adjustment, invoice: invoice, line_item: line_item2, amount_in_cents: 1000) }
    let(:tax_adjustment1) { create(:tax_adjustment, invoice: invoice, line_item: line_item1, amount_in_cents: 100) }
    let(:tax_adjustment2) { create(:tax_adjustment, invoice: invoice, line_item: line_item2, amount_in_cents: 100) }
    let(:payment_adjustment1) { create(:payment_adjustment, invoice: invoice, line_item: line_item1, amount_in_cents: -1100) }
    let(:payment_adjustment2) { create(:payment_adjustment, invoice: invoice, line_item: line_item2, amount_in_cents: -1100) }
    let(:overpayment_adjustment1) { create(:payment_adjustment, invoice: invoice, line_item: line_item1, amount_in_cents: -1200) }
    let(:overpayment_adjustment2) { create(:payment_adjustment, invoice: invoice, line_item: line_item2, amount_in_cents: -1200) }

    context "with no adjustments" do
      before do
        invoice
      end

      it "should sum up to 0" do
        expect(invoice.total).to eq(0)
      end

      it "should be paid" do
        # this might seem nonsensical, but there are no costs or charges on the invoice, everything on the invoice has been paid
        expect(invoice.paid?).to eq(true)
      end

      it "should not be overpaid" do
        expect(invoice.overpaid?).to eq(false)
      end
    end

    context "with base adjustments" do
      before do
        base_adjustment1
        base_adjustment2
      end

      it "should sum up to 2000" do
        expect(invoice.total).to eq(2000)
      end

      it "should not be paid" do
        expect(invoice.paid?).to eq(false)
      end

      it "should not be overpaid" do
        expect(invoice.overpaid?).to eq(false)
      end
    end

    context "with tax adjustments" do
      before do
        base_adjustment1
        base_adjustment2
        tax_adjustment1
        tax_adjustment2
      end

      it "should sum up to 2200" do
        expect(invoice.total).to eq(2200)
       end

      it "should not be paid" do
        expect(invoice.paid?).to eq(false)
      end

      it "should not be overpaid" do
        expect(invoice.overpaid?).to eq(false)
      end
    end

    context "with payment and tax adjustments" do
      before do
        base_adjustment1
        base_adjustment2
        tax_adjustment1
        tax_adjustment2
        payment_adjustment1
        payment_adjustment2
      end

      it "should sum up to 0" do
        expect(invoice.total).to eq(0)
      end

      it "should be paid" do
        expect(invoice.paid?).to eq(true)
      end

      it "should not be overpaid" do
        expect(invoice.overpaid?).to eq(false)
      end
    end

    context "with overpayment and tax adjustments" do
      before do
        base_adjustment1
        base_adjustment2
        tax_adjustment1
        tax_adjustment2
        overpayment_adjustment1
        overpayment_adjustment2
      end

      it "should sum up to 0" do
        expect(invoice.total).to eq(-200)
      end

      it "should not be paid" do
        expect(invoice.paid?).to eq(false)
      end

      it "should be overpaid" do
        expect(invoice.overpaid?).to eq(true)
      end
    end
  end
end
