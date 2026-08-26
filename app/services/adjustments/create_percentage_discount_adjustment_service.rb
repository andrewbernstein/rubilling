class Adjustments::CreatePercentageDiscountAdjustmentService
  prepend ServiceMonitoring

  # percentage should be the decimal representation of the percentage that the fee is for
  # i.e. if it's a 20% fee, percentage should be .2
  # even though we're discounting and reducing the effective price of the line item, pass in a
  # positive percentage
  def initialize(line_item:, percentage:)
    @line_item = line_item
    @percentage = percentage
  end

  def call
    Adjustments::CreateAdjustmentService.new(
      line_item: @line_item,
      adjustment_type: Adjustment::DISCOUNT_TYPE,
      amount_in_cents: -1 * @line_item.base_adjustment.amount_in_cents * @percentage
    ).call
  end
end
