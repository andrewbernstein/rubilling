require "rails_helper"

describe Adjustments::CreateTaxAdjustmentService do
  describe "#call" do
    let(:invoice) { create(:invoice) }
    let(:line_item) { create(:line_item, :with_base_adjustment, invoice: invoice) }
    let(:amount_in_cents) { 100 }
    let(:result) { described_class.new(line_item: line_item, amount_in_cents: amount_in_cents).call }

    it "creates a new tax adjustment for the line item" do
      result
      expect(Adjustment.count).to eq(2)
      new_adjustment = Adjustment.last
      expect(new_adjustment.line_item).to eq(line_item)
      expect(new_adjustment.invoice).to eq(invoice)
      expect(new_adjustment.adjustment_type).to eq(Adjustment::TAX_TYPE)
      expect(new_adjustment.amount_in_cents).to eq(amount_in_cents)
    end
  end
end
