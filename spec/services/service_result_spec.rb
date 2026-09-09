require 'rails_helper'

describe ServiceResult do
  let(:result) { described_class.new }

  describe "#error!" do
    context "adding errors" do
      it "adds an error" do
        result.error!("this is an error")
        expect(result.errors.count).to eq(1)
        expect(result.errors.first).to eq("this is an error")
      end

      it "marks the result a failure" do
        result.error!("this is an error")
        expect(result.results[:success]).to eq(false)
        expect(result.failure?).to eq(true)
        expect(result.success?).to eq(false)
      end
    end
  end

  describe "#success!" do
    context "when marking success" do
      it "marks the result a success" do
        result.success!
        expect(result.results[:success]).to eq(true)
        expect(result.success?).to eq(true)
        expect(result.failure?).to eq(false)
      end

      it "does not add any errors" do # why would it?
        result.success!
        expect(result.errors.count).to eq(0)
      end
    end

    context "after already marking failure" do
      it "raises an exception" do
        result.failure!
        expect { result.success! }.to raise_error(ServiceResult::AlreadyMarkedFailureError)
      end
    end
  end

  describe "#success?" do
    context "after marking success" do
      it "returns true" do
        result.success!
        expect(result.success?).to eq(true)
      end
    end

    context "after marking failure" do
      it "returns false" do
        result.failure!
        expect(result.success?).to eq(false)
      end
    end

    context "after not marking success or failure" do
      it "returns false" do
        expect(result.success?).to eq(false)
      end
    end
  end

  describe "#failure!" do
    context "when marking failure" do
      it "marks the result a failure" do
        result.failure!
        expect(result.results[:success]).to eq(false)
        expect(result.failure?).to eq(true)
        expect(result.success?).to eq(false)
      end

      it "does not add any errors" do
        result.failure!
        expect(result.errors.count).to eq(0)
      end
    end

    context "after already marking success" do
      it "raises a AlreadyMarkedSuccess error" do
        result.success!
        expect { result.failure! }.to raise_error(ServiceResult::AlreadyMarkedSuccessError)
      end
    end
  end

  describe "#failure?" do
    context "after marking success" do
      it "returns false" do
        result.success!
        expect(result.failure?).to eq(false)
      end
    end

    context "after marking failure" do
      it "returns true" do
        result.failure!
        expect(result.failure?).to eq(true)
      end
    end

    context "after not marking success or failure" do
      it "returns false" do
        expect(result.success?).to eq(false)
      end
    end
  end
end
