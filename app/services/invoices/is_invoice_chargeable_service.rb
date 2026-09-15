class Invoices::IsInvoiceChargeableService
  prepend ServiceMonitoring

  # check to see if an invoice is in a chargeable state
  # handles checks for whether it's already been paid, verifying that the invoice has taxes
  # (if it doesn't, set expect_no_taxes to true), verifying that it has line items
  # PLEASE NOTE: this list is likely to grow as more cases are handled
  # TODO: data drive this?
  def initialize(invoice:, expect_no_taxes: false)
    @invoice = invoice
    @expect_no_taxes = expect_no_taxes
  end

  def call
    result = ServiceResult.new
    result.error!("no line items") unless @invoice.line_items.any?
    result.error!("already paid") if @invoice.paid?
    result.error!("no taxes") if tax_adjustments.none? && !@expect_no_taxes
    result.error!("has taxes") if tax_adjustments.any? && @expect_no_taxes

    if result.failure?
      result.chargeable = false
      set_failed_validation_end_status
    else
      result.chargeable = true
      result.success!
    end

    result
  end

  def tax_adjustments
    @invoice.adjustments.where(adjustment_type: Adjustment::TAX_TYPE)
  end
end
