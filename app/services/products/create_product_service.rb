class Products::CreateProductService
  include ServiceMonitoring

  def initialize(name:)
    @name = name
  end

  def call
    result = ServiceResult.new

    product = Product.new(name: @name)
    product.save!

    result.product = product
    result.success!
  end
end
