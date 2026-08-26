class PaymentMethods::CreatePaymentMethodService
  prepend ServiceMonitoring

  def initialize(payment_processor:, entity:)
    @payment_processor = payment_processor
    @entity = entity
  end

  def call
    payment_method = PaymentMethod.new(
      payment_processor: @payment_processor,
      entity: @entity
    )
    payment_method.save!

    payment_method
  end
end
