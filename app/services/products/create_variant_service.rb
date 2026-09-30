class Products::CreateVariantService
  prepend ServiceMonitoring

  def initialize(product:, name:, amount_in_cents:)
    @product = product
    @name = name
    @amount_in_cents = amount_in_cents
  end

  def call
    result = ServiceResult.new

    variant = Variant.new(
      product: @product,
      name: @name,
      amount_in_cents: @amount_in_cents
    )
    variant.save

    if variant.errors.present?
      variant.errors.each { |error| result.error!(error.full_message) }
      set_failed_validation_end_status
      result
    else
      result.variant = variant
      result.success!
    end
  end
end
