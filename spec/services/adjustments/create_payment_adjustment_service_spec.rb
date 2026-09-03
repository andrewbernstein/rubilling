require "rails_helper"

describe Adjustments::CreatePaymentAdjustmentService do
  describe "#call" do
    let(:invoice) { create(:invoice) }
    let(:line_item) { create(:line_item, :with_base_adjustment, invoice: invoice) }
    let(:amount_in_cents) { 200 }
    let(:result) { described_class.new(line_item: line_item, amount_in_cents: amount_in_cents).call }
    let(:create_adjustment_service_double) { double }

    before do
      allow(Adjustments::CreateAdjustmentService).to receive(:new).and_return(create_adjustment_service_double)
      allow(create_adjustment_service_double).to receive(:call)
    end

    it "calls Adjustments::CreateAdjustmentService to create the adjustment" do
      result
      expect(Adjustments::CreateAdjustmentService).to have_received(:new).with(
        adjustment_type: Adjustment::PAYMENT_TYPE,
        amount_in_cents: -1 * amount_in_cents,
        line_item: line_item
      )
      expect(create_adjustment_service_double).to have_received(:call)
    end

    context "log creation" do
      it "creates a log for the service call" do
        result
        expect(Log.count).to eq(1)
        expect(Log.where(
          action: 'Adjustments::CreatePaymentAdjustmentService',
          status: 'successful'
        ).first).to be_present
      end
    end
  end
end
