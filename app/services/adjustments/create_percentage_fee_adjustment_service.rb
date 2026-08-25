class Adjustments::CreatePercentageFeeAdjustmentService
  prepend ServiceMonitoring

  # percentage should be the decimal representation of the percentage that the fee is for
  # i.e. if it's a 20% fee, percentage should be .2
  def initialize(line_item:, percentage:)
    @line_item = line_item
    @percentage = percentage
  end

  def call
    Adjustments::CreateAdjustmentService.new(
      line_item: @line_item,
      adjustment_type: Adjustment::FEE_TYPE,
      amount_in_cents: @line_item.base_adjustment.amount_in_cents * @percentage
    ).call
  end
end
