require "rails_helper"

# == Schema Information
#
# Table name: line_items
#
#  id         :bigint           not null, primary key
#  quantity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  invoice_id :bigint
#  variant_id :bigint
#
describe LineItem do
  describe "#base_adjustment" do
    let(:line_item) { create(:line_item) }
    let(:base_adjustment) { create(:base_adjustment, line_item: line_item) }
    let(:adjustments) do
      [
        base_adjustment
      ]
    end

    before do
      line_item
      adjustments
    end

    context "with no other adjustments" do
      it "should return base adjustment" do
        expect(line_item.base_adjustment).to eq(base_adjustment)
      end
    end

    context "with other adjustments" do
      let(:adjustments) do
        [
          base_adjustment,
          create(:tax_adjustment, line_item: line_item),
          create(:fee_adjustment, line_item: line_item),
          create(:payment_adjustment, line_item: line_item)
        ]
      end

      it "should return base adjustment" do
        expect(line_item.base_adjustment).to eq(base_adjustment)
      end
    end

    context "with no base adjustment" do
      let(:adjustments) { [] }

      it "should return nil" do
        expect(line_item.base_adjustment).to be_nil
      end
    end
  end
end
