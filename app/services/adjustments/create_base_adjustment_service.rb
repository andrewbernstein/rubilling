class Adjustments::CreateBaseAdjustmentService
  prepend ServiceMonitoring

  def initialize(line_item:)
    @line_item = line_item
  end

  def call
    adjustment = Adjustment.new(
      line_item: @line_item,
      invoice: @line_item.invoice,
      adjustment_type: Adjustment::BASE_TYPE,
      amount_in_cents: @line_item.variant.amount_in_cents * @line_item.quantity
    )
    adjustment.save!

    adjustment
  end
end
