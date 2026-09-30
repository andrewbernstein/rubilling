require "rails_helper"

describe Products::CreateVariantService do
  let(:result) { described_class.new(name: name, product: product, amount_in_cents: amount_in_cents).call }
  let(:name) { "a product name" }
  let(:product) { create(:product) }
  let(:amount_in_cents) { 1000 }

  context "with all parameters" do
    it "returns successfully" do
      expect(result.success?).to be(true)
    end

    it "creates a new variant" do
      expect(result.success?).to be(true)
      expect(Variant.count).to eq(1)
      variant = Variant.first
      expect(variant.product).to eq(product)
      expect(variant.name).to eq(name)
      expect(variant.amount_in_cents).to eq(amount_in_cents)
    end

    context "log creation" do
      it "creates a log for the service call" do
        result
        expect(Log.count).to eq(1)
        log = Log.first
        expect(log.action).to eq("Products::CreateVariantService")
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
      expect(log.action).to eq("Products::CreateVariantService")
      expect(log.status).to eq("failed_validation")
    end
  end

  context "without product" do
    let(:product) { nil }

    it "is not successful" do
      expect(result.success?).to eq(false)
    end

    it "returns a name error" do
      expect(result.success?).to eq(false)
      expect(result.errors).to include("Product must exist")
    end

    it "creates a failed validation log" do
      expect(result.success?).to eq(false)
      expect(Log.count).to eq(1)
      log = Log.first
      expect(log.action).to eq("Products::CreateVariantService")
      expect(log.status).to eq("failed_validation")
    end
  end

  context "without amount_in_cents" do
    let(:amount_in_cents) { nil }

    it "is not successful" do
      expect(result.success?).to eq(false)
    end

    it "returns a name error" do
      expect(result.success?).to eq(false)
      expect(result.errors).to include("Amount in cents can't be blank")
    end

    it "creates a failed validation log" do
      expect(result.success?).to eq(false)
      expect(Log.count).to eq(1)
      log = Log.first
      expect(log.action).to eq("Products::CreateVariantService")
      expect(log.status).to eq("failed_validation")
    end
  end

  context "when called twice with the same parameters" do
    let(:second_result) { described_class.new(name: name, product: product, amount_in_cents: amount_in_cents).call }

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
      expect(Log.first.action).to eq("Products::CreateVariantService")
      expect(Log.first.status).to eq("successful")
      expect(Log.second.action).to eq("Products::CreateVariantService")
      expect(Log.second.status).to eq("failed_validation")
    end
  end
end
