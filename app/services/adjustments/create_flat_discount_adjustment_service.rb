class Adjustments::CreateFlatDiscountAdjustmentService
  prepend ServiceMonitoring

  # pass in a positive amount in cents for discount
  def initialize(line_item:, amount_in_cents:)
    @line_item = line_item
    @amount_in_cents = amount_in_cents
  end

  def call
    Adjustments::CreateAdjustmentService.new(
      line_item: @line_item,
      adjustment_type: Adjustment::DISCOUNT_TYPE,
      amount_in_cents: -1 * @amount_in_cents
    ).call
  end
end
