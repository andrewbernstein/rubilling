require "rails_helper"

describe Adjustments::CreateBaseAdjustmentService do
  describe "#call" do
    let(:line_item) { FactoryBot.create(:line_item) }
    let(:create_adjustment_service_double) { double }

    let(:result) do
      described_class.new(
        line_item: line_item
      ).call
    end

    before do
      allow(Adjustments::CreateAdjustmentService).to receive(:new).and_return(create_adjustment_service_double)
      allow(create_adjustment_service_double).to receive(:call)
    end

    it "calls Adjustments::CreateAdjustmentService to create the adjustment" do
      result
      expect(Adjustments::CreateAdjustmentService).to have_received(:new).with(
        adjustment_type: Adjustment::BASE_TYPE,
        amount_in_cents: 1000,
        line_item: line_item
      )
      expect(create_adjustment_service_double).to have_received(:call)
    end

    context "log creation" do
      it "creates a log for the service call" do
        result
        expect(Log.count).to eq(1)
        expect(Log.where(
          action: 'Adjustments::CreateBaseAdjustmentService',
          status: 'successful'
        ).first).to be_present
      end
    end
  end
end
