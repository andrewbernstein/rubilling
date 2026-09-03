class Adjustments::CreatePaymentAdjustmentService
  prepend ServiceMonitoring

  def initialize(line_item:, amount_in_cents:)
    @line_item = line_item
    @amount_in_cents = amount_in_cents
  end

  def call
    Adjustments::CreateAdjustmentService.new(
      line_item: @line_item,
      adjustment_type: Adjustment::PAYMENT_TYPE,
      amount_in_cents: -1 * @amount_in_cents # payment adjustments are negative to offset positive cost adjustments!
    ).call
  end
end
