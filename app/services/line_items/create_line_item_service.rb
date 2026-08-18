class LineItems::CreateLineItemService
  prepend ServiceMonitoring

  def initialize(invoice:, variant:, quantity:)
    @invoice = invoice
    @variant = variant
    @quantity = quantity
  end

  def call
    line_item = nil

    # we don't want line items without base adjustments if possible, so we're wrapping this in a transaction
    LineItem.transaction do
      line_item = LineItem.new(
        invoice: @invoice,
        variant: @variant,
        quantity: @quantity
      )
      line_item.save!

      Adjustments::CreateBaseAdjustmentService.new(
        line_item: line_item
      ).call
    end

    line_item
  end
end
