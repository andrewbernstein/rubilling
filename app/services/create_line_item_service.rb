class CreateLineItemService
  prepend ServiceMonitoring

  def initialize(invoice:, variant:, quantity:)
    @invoice = invoice
    @variant = variant
    @quantity = quantity
  end

  def call
    # we don't want line items without base adjustments if possible, so we're wrapping this in a transaction
    LineItem.transaction do
      line_item = LineItem.new(
        invoice: @invoice,
        variant: @variant,
        quantity: @quantity
      ).save!

      CreateBaseAdjustmentService.new(
        line_item: line_item
      ).call
    end
  end
end
