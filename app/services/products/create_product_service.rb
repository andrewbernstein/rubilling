class Products::CreateProductService
  prepend ServiceMonitoring

  def initialize(name:, category: nil)
    @name = name
    @category = category
  end

  def call
    result = ServiceResult.new

    product = Product.new(name: @name)
    product.category = @category if @category.present?

    product.save
    if product.errors.present?
      product.errors.each { |error| result.error!(error.full_message) }
      set_failed_validation_end_status
      result
    else
      result.product = product
      result.success!
    end
  end
end
