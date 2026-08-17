require "rails_helper"

describe CreateBaseAdjustmentService do
  describe "#call" do
    let(:line_item) { FactoryBot.create(:line_item) }

    let(:result) do
      described_class.new(
        line_item: line_item
      ).call
    end

    it "creates a base line item adjustment" do
      result
      expect(Adjustment.count).to eq(1)
      adjustment = Adjustment.first
      expect(adjustment.invoice).to eq(line_item.invoice)
      expect(adjustment.line_item).to eq(line_item)
      expect(adjustment.adjustment_type).to eq(Adjustment::BASE_TYPE)
      expect(adjustment.amount_in_cents).to eq(line_item.variant.amount_in_cents * line_item.quantity)
    end

    context "log creation" do
      it "creates a log for the service call" do
        result
        expect(Log.count).to eq(1)
        log = Log.first
        expect(log.action).to eq('CreateBaseAdjustmentService')
        expect(log.status).to eq('successful')
      end
    end
  end
end
