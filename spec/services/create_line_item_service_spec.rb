require "rails_helper"

describe CreateLineItemService do
  describe "#call" do
    let(:invoice) { FactoryBot.create(:invoice) }
    let(:variant) { FactoryBot.create(:variant) }
    let(:quantity) { 1 }

    let(:result) do
      described_class.new(
        invoice: invoice,
        variant: variant,
        quantity: quantity
      ).call
    end

    it "creates a new line item" do
      result
      expect(LineItem.count).to eq(1)
      line_item = LineItem.first
      expect(line_item.invoice).to eq(invoice)
      expect(line_item.variant).to eq(variant)
      expect(line_item.quantity).to eq(quantity)
    end

    context "log creation" do
      let(:base_line_item_service_dummy) { double }

      before do
        allow(CreateBaseAdjustmentService).to receive(:new).and_return(base_line_item_service_dummy)
        allow(base_line_item_service_dummy).to receive(:call)
      end

      it "creates a log for the service call" do
        result
        expect(Log.count).to eq(1)
        log = Log.first
        expect(log.action).to eq('CreateLineItemService')
        expect(log.status).to eq('successful')
      end
    end
  end
end
