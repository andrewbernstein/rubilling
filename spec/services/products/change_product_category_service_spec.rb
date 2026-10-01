require "rails_helper"

describe Products::ChangeProductCategoryService do
  let(:result) { described_class.new(product: product, new_category: category).call }
  let(:product) { create(:product) }
  let(:category) { create(:category) }

  context "with a category present" do
    it "returns successfully" do
      expect(result.success?).to be(true)
    end

    it "changes the category" do
      expect(result.success?).to be(true)
      expect(product.category).to eq(category)
    end

    context "log creation" do
      it "creates a log for the service call" do
        result
        expect(Log.count).to eq(1)
        log = Log.first
        expect(log.action).to eq("Products::ChangeProductCategoryService")
        expect(log.status).to eq("successful")
      end
    end
  end

  context "without a category present" do
    let(:category) { nil }

    it "returns successfully" do
      expect(result.success?).to be(true)
    end

    it "changes the category" do
      expect(result.success?).to be(true)
      expect(product.category).to eq(category)
    end

    context "log creation" do
      it "creates a log for the service call" do
        result
        expect(Log.count).to eq(1)
        log = Log.first
        expect(log.action).to eq("Products::ChangeProductCategoryService")
        expect(log.status).to eq("successful")
      end
    end
  end
end
