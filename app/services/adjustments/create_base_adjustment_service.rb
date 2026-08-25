class Adjustments::CreateBaseAdjustmentService
  prepend ServiceMonitoring

  class BaseAdjustmentAlreadyExistsError < StandardError; end

  def initialize(line_item:)
    @line_item = line_item
  end

  def call
    # we should not create more than one base adjustment per line item, this would be very bad
    raise BaseAdjustmentAlreadyExistsError, "Line item #{@line_item.id} already has a base adjustment!" if @line_item.base_adjustment.present?

    Adjustments::CreateAdjustmentService.new(
      line_item: @line_item,
      adjustment_type: Adjustment::BASE_TYPE,
      amount_in_cents: @line_item.variant.amount_in_cents * @line_item.quantity
    ).call
  end
end
