require "rails_helper"

describe PaymentMethods::CreatePaymentMethodService do
  describe "#call" do
    let(:payment_processor) { "Stripe" }
    let(:entity) { create(:entity) }

    let(:result) do
      described_class.new(
        payment_processor: payment_processor,
        entity: entity
      ).call
    end

    context "with default parameters" do
      it "creates a new invoice" do
        result
        expect(PaymentMethod.count).to eq(1)
        payment_method = PaymentMethod.first
        expect(payment_method.payment_processor).to eq(payment_processor)
        expect(payment_method.entity).to eq(entity)
      end
    end

    context "log creation" do
      it "creates a log for the service call" do
        result
        expect(Log.count).to eq(1)
        log = Log.first
        expect(log.action).to eq('PaymentMethods::CreatePaymentMethodService')
        expect(log.status).to eq('successful')
      end
    end
  end
end
