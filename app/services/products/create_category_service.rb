class Products::CreateCategoryService
  prepend ServiceMonitoring

  def initialize(name:)
    @name = name
  end

  def call
    result = ServiceResult.new

    category = Category.new(
      name: @name
    )
    category.save

    if category.errors.present?
      category.errors.each { |error| result.error!(error.full_message) }
      set_failed_validation_end_status
      result
    else
      result.category = category
      result.success!
    end
  end
end
