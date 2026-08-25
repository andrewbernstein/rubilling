require "rails_helper"

describe Tax::CreateTaxAdjustmentsService do
  context "#call" do
    let(:result) { described_class.new(adjustment_info: adjustment_info).call }
    let(:adjustment_info) { [] }
    let(:create_tax_adjustment_service_double) { double }

    before do
      allow(Adjustments::CreateTaxAdjustmentService).to receive(:new).and_return(create_tax_adjustment_service_double)
      allow(create_tax_adjustment_service_double).to receive(:call)
    end

    context "with one line item with one tax adjustment info" do
      let(:line_item) { create(:line_item, :with_base_adjustment) }
      let(:adjustment_info) do
        [
          {
            line_item_id: line_item.id,
            tax_adjustment_info: [
              {
                amount_in_cents: 100
              }
            ]
          }
        ]
      end

      it "calls Adjustments::CreateTaxAdjustmentService once" do
        result
        expect(Adjustments::CreateTaxAdjustmentService).to have_received(:new).with(
          line_item: line_item,
          amount_in_cents: 100
        )
        expect(create_tax_adjustment_service_double).to have_received(:call).once
      end
    end

    context "with two line items each with one tax adjustment info" do
      let(:line_item1) { create(:line_item, :with_base_adjustment) }
      let(:line_item2) { create(:line_item, :with_base_adjustment) }
      let(:adjustment_info) do
        [
          {
            line_item_id: line_item1.id,
            tax_adjustment_info: [
              {
                amount_in_cents: 100
              }
            ]
          },
          {
            line_item_id: line_item2.id,
            tax_adjustment_info: [
              {
                amount_in_cents: 200
              }
            ]
          }
        ]
      end

      it "calls Adjustments::CreateTaxAdjustmentService twice" do
        result
        expect(Adjustments::CreateTaxAdjustmentService).to have_received(:new).with(
          line_item: line_item1,
          amount_in_cents: 100
        )
        expect(Adjustments::CreateTaxAdjustmentService).to have_received(:new).with(
          line_item: line_item2,
          amount_in_cents: 200
        )
        expect(create_tax_adjustment_service_double).to have_received(:call).twice
      end
    end

    context "with two line items each with two tax adjustment infos" do
      let(:line_item1) { create(:line_item, :with_base_adjustment) }
      let(:line_item2) { create(:line_item, :with_base_adjustment) }
      let(:adjustment_info) do
        [
          {
            line_item_id: line_item1.id,
            tax_adjustment_info: [
              {
                amount_in_cents: 100
              },
              {
                amount_in_cents: 300
              }
            ]
          },
          {
            line_item_id: line_item2.id,
            tax_adjustment_info: [
              {
                amount_in_cents: 200
              },
              {
                amount_in_cents: 400
              }
            ]
          }
        ]
      end

      it "calls Adjustments::CreateTaxAdjustmentService twice" do
        result
        expect(Adjustments::CreateTaxAdjustmentService).to have_received(:new).with(
          line_item: line_item1,
          amount_in_cents: 100
        )
        expect(Adjustments::CreateTaxAdjustmentService).to have_received(:new).with(
          line_item: line_item1,
          amount_in_cents: 300
        )
        expect(Adjustments::CreateTaxAdjustmentService).to have_received(:new).with(
          line_item: line_item2,
          amount_in_cents: 200
        )
        expect(Adjustments::CreateTaxAdjustmentService).to have_received(:new).with(
          line_item: line_item2,
          amount_in_cents: 400
        )
        expect(create_tax_adjustment_service_double).to have_received(:call).exactly(4).times
      end
    end
  end
end
