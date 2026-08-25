require "rails_helper"

describe Adjustments::CreateAdjustmentService do
  describe "#call" do
    let(:line_item) { FactoryBot.create(:line_item) }
    let(:base_adjustment) { FactoryBot.create(:base_adjustment, line_item: line_item) }
    let(:adjustment_type) { 'foo' }
    let(:amount_in_cents) { 100 }

    let(:result) do
      described_class.new(
        line_item: line_item,
        adjustment_type: adjustment_type,
        amount_in_cents: amount_in_cents
      ).call
    end

    Adjustment::ADJUSTMENT_TYPES.each do |adjustment_type|
      context "for #{adjustment_type} adjustments" do
        let(:adjustment_type) { adjustment_type }

        before do
          # create a base adjustment for the line item unless we're testing creating one
          base_adjustment unless adjustment_type == Adjustment::BASE_TYPE
        end

        it "creates an adjustment" do
          result
          last_adjustment = Adjustment.last
          expect(last_adjustment.line_item).to eq(line_item)
          expect(last_adjustment.invoice).to eq(line_item.invoice)
          expect(last_adjustment.adjustment_type).to eq(adjustment_type)
          expect(last_adjustment.amount_in_cents).to eq(amount_in_cents)
        end

        context "log creation" do
          it "creates a log for the service call" do
            result
            expect(Log.count).to eq(1)
            expect(Log.where(
              action: 'Adjustments::CreateAdjustmentService',
              status: 'successful'
            ).first).to be_present
          end
        end
      end
    end
  end
end
