class Adjustments::CreateFlatFeeAdjustmentService
  prepend ServiceMonitoring

  def initialize(line_item:, amount_in_cents:)
    @line_item = line_item
    @amount_in_cents = amount_in_cents
  end

  def call
    Adjustments::CreateAdjustmentService.new(
      line_item: @line_item,
      adjustment_type: Adjustment::FEE_TYPE,
      amount_in_cents: @amount_in_cents
    ).call
  end
end
