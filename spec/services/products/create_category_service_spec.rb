require "rails_helper"

describe Products::CreateCategoryService do
  let(:result) { described_class.new(name: name).call }
  let(:name) { "a product name" }

  context "with all parameters" do
    it "returns successfully" do
      expect(result.success?).to be(true)
    end

    it "creates a new variant" do
      expect(result.success?).to be(true)
      expect(Category.count).to eq(1)
      category = Category.first
      expect(category.name).to eq(name)
    end

    context "log creation" do
      it "creates a log for the service call" do
        result
        expect(Log.count).to eq(1)
        log = Log.first
        expect(log.action).to eq("Products::CreateCategoryService")
        expect(log.status).to eq("successful")
      end
    end
  end

  context "without name" do
    let(:name) { nil }

    it "is not successful" do
      expect(result.success?).to eq(false)
    end

    it "returns a name error" do
      expect(result.success?).to eq(false)
      expect(result.errors).to include("Name can't be blank")
    end

    it "creates a failed validation log" do
      expect(result.success?).to eq(false)
      expect(Log.count).to eq(1)
      log = Log.first
      expect(log.action).to eq("Products::CreateCategoryService")
      expect(log.status).to eq("failed_validation")
    end
  end

  context "when called twice with the same parameters" do
    let(:second_result) { described_class.new(name: name).call }

    it "errors out on the second call" do
      expect(result.success?).to eq(true)
      expect(second_result.success?).to eq(false)
    end

    it "returns a name has already been taken error" do
      expect(result.success?).to eq(true)
      expect(second_result.success?).to eq(false)
      expect(second_result.errors).to include("Name has already been taken")
    end

    it "creates a failed validation log" do
      expect(result.success?).to eq(true)
      expect(second_result.success?).to eq(false)
      expect(Log.count).to eq(2)
      expect(Log.first.action).to eq("Products::CreateCategoryService")
      expect(Log.first.status).to eq("successful")
      expect(Log.second.action).to eq("Products::CreateCategoryService")
      expect(Log.second.status).to eq("failed_validation")
    end
  end
end
