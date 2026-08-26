require "rails_helper"

describe Adjustments::CreatePercentageDiscountAdjustmentService do
  describe "#call" do
    let(:invoice) { create(:invoice) }
    let(:line_item) { create(:line_item, :with_base_adjustment, invoice: invoice) }
    let(:percentage) { 0.2 }
    let(:result) { described_class.new(line_item: line_item, percentage: percentage).call }
    let(:create_adjustment_service_double) { double }

    before do
      allow(Adjustments::CreateAdjustmentService).to receive(:new).and_return(create_adjustment_service_double)
      allow(create_adjustment_service_double).to receive(:call)
    end

    it "calls Adjustments::CreateAdjustmentService to create the adjustment" do
      result
      expect(Adjustments::CreateAdjustmentService).to have_received(:new).with(
        adjustment_type: Adjustment::DISCOUNT_TYPE,
        amount_in_cents: -1 * line_item.base_adjustment.amount_in_cents * percentage,
        line_item: line_item
      )
      expect(create_adjustment_service_double).to have_received(:call)
    end

    context "log creation" do
      it "creates a log for the service call" do
        result
        expect(Log.count).to eq(1)
        expect(Log.where(
          action: 'Adjustments::CreatePercentageDiscountAdjustmentService',
          status: 'successful'
        ).first).to be_present
      end
    end
  end
end
