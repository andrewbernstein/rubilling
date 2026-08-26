require "rails_helper"

describe Entities::CreateEntityService do
  describe "#call" do
    let(:name) { "Tom Swift" }
    let(:external_id) { "12345" }

    let(:result) do
      described_class.new(
        name: name,
        external_id: external_id
      ).call
    end

    context "with default parameters" do
      it "creates a new invoice" do
        result
        expect(Entity.count).to eq(1)
        entity = Entity.first
        expect(entity.name).to eq(name)
        expect(entity.external_id).to eq(external_id)
      end
    end

    context "log creation" do
      it "creates a log for the service call" do
        result
        expect(Log.count).to eq(1)
        log = Log.first
        expect(log.action).to eq('Entities::CreateEntityService')
        expect(log.status).to eq('successful')
      end
    end
  end
end
