require "rails_helper"

describe Products::CreateProductService do
  let(:result) { described_class.new(name: name).call }
  let(:name) { "a product name" }

  describe "#call" do
    it "is called successfully" do
      expect(result.success?).to eq(true)
    end

    it "creates a product" do
      expect(result.success?).to eq(true)
      expect(Product.count).to eq(1)
      expect(Product.first.name).to eq(name)
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
end
