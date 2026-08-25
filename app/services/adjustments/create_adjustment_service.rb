class Adjustments::CreateAdjustmentService
  prepend ServiceMonitoring

  # this is a helper class to create adjustments for parent classes that will create specific types of adjustments!
  # do not call this from anywhere other than a Create(adjustment type)AdjustmentService class!
  def initialize(line_item:, adjustment_type:, amount_in_cents:)
    @line_item = line_item
    @adjustment_type = adjustment_type
    @amount_in_cents = amount_in_cents
  end

  def call
    adjustment = Adjustment.new(
      line_item: @line_item,
      invoice: @line_item.invoice,
      adjustment_type: @adjustment_type,
      amount_in_cents: @amount_in_cents
    )
    adjustment.save!

    adjustment
  end
end
