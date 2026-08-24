class Adjustments::CreateTaxAdjustmentService
  def initialize(line_item:, amount_in_cents:)
    @line_item = line_item
    @amount_in_cents = amount_in_cents
  end

  def call
    adjustment = Adjustment.new(
      line_item: @line_item,
      invoice: @line_item.invoice,
      adjustment_type: Adjustment::TAX_TYPE,
      amount_in_cents: @amount_in_cents
    )
    adjustment.save!
    adjustment
  end
end
