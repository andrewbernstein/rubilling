require "rails_helper"

describe Products::CreateProductService do
  let(:result) { described_class.new(name: name, category: category).call }
  let(:name) { "a product name" }
  let(:category) { nil }

  describe "#call" do
    context "when called once" do
      it "is called successfully" do
        expect(result.success?).to eq(true)
      end

      it "creates a product" do
        expect(result.success?).to eq(true)
        expect(Product.count).to eq(1)
        expect(Product.first.name).to eq(name)
        expect(Product.first.category).to eq(nil)
      end

      context "log creation" do
        it "creates a log for the service call" do
          result
          expect(Log.count).to eq(1)
          log = Log.first
          expect(log.action).to eq('Products::CreateProductService')
          expect(log.status).to eq('successful')
        end
      end
    end

    context "when giving it a category" do
      let(:category) { create(:category) }

      it "is called successfully" do
        expect(result.success?).to eq(true)
      end

      it "creates a product with a category" do
        expect(result.success?).to eq(true)
        expect(Product.count).to eq(1)
        expect(Product.first.name).to eq(name)
        expect(Product.first.category).to eq(category)
      end

      context "log creation" do
        it "creates a log for the service call" do
          result
          expect(Log.count).to eq(1)
          log = Log.first
          expect(log.action).to eq('Products::CreateProductService')
          expect(log.status).to eq('successful')
        end
      end
    end

    context "when called twice with the same parameters" do
      it "fails on the second call" do
        expect(result.success?).to eq(true)
        second_result = described_class.new(name: name, category: category).call
        expect(second_result.success?).to eq(false)
      end

      it "only creates one product" do
        expect(result.success?).to eq(true)
        second_result = described_class.new(name: name, category: category).call
        expect(Product.count).to eq(1)
      end

      it "returns a non-unique name error on the second call" do
        expect(result.success?).to eq(true)
        second_result = described_class.new(name: name, category: category).call
        expect(second_result.errors.count).to eq(1)
        expect(second_result.errors.first).to eq("Name has already been taken")
      end

      context "log creation" do
        it "creates a log for the service call and a failed validation log for the failure" do
          result
          second_result = described_class.new(name: name, category: category).call
          expect(Log.count).to eq(2)
          log = Log.first
          expect(log.action).to eq('Products::CreateProductService')
          expect(log.status).to eq('successful')
          log = Log.second
          expect(log.action).to eq('Products::CreateProductService')
          expect(log.status).to eq('failed_validation')
        end
      end
    end
  end
end
