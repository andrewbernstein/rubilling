class Products::ChangeProductCategoryService
  prepend ServiceMonitoring

  def initialize(product:, new_category:)
    @product = product
    @new_category = new_category
  end

  def call
    result = ServiceResult.new

    @product.category = @new_category
    @product.save

    if @product.errors.present?
      @product.errors.each { |error| result.error!(error.full_message) }
      set_failed_validation_end_status
      result
    else
      result.product = @product
      result.success!
    end
  end
end
