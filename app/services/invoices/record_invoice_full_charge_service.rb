class Invoices::RecordInvoiceFullChargeService
  prepend ServiceMonitoring

  def initialize(invoice:, payment_method:, amount_in_cents:, options: {})
    @invoice = invoice
    @payment_method = payment_method
    @amount_in_cents = amount_in_cents
    @options = options
  end

  def call
    result = {
      errors: [],
      success: false
    }

    # validate that the invoice is in a chargeable state
    validation_result = Invoices::IsInvoiceChargeableService.new(
      invoice: @invoice,
      expect_no_taxes: @options[:expect_no_taxes] || false
    ).call
    if validation_result[:errors].any?
      set_failed_validation_end_status
      result[:errors] = validation_result[:errors]
      return result
    end

    # for now, we're not supporting over- or under-payment of invoices
    # TODO: support overpayment or underpayment of invoices!
    # (probably in a separate service as we may or may not have specific invoices to apply the payment to yet)
    if @amount_in_cents != @invoice.total
      set_failed_validation_end_status
      result[:errors] << "amount in cents does not match invoice total"
      return result
    end

    # we've received notification that an invoice has been charged, so we have to create lots of models in a transaction for consistency
    Invoice.transaction do
      payment_transaction = Transaction.new(
        payment_method: @payment_method,
        amount_in_cents: @amount_in_cents
      )
      payment_transaction.save!

      applied_transaction = AppliedTransaction.new(
        invoice: @invoice,
        payment_transaction: payment_transaction,
        amount_in_cents: @amount_in_cents
      )
      applied_transaction.save!

      # since we've paid the whole invoice, we can just create payment adjustments for each line item on the invoice
      @invoice.line_items.each do |line_item|
        Adjustments::CreatePaymentAdjustmentService.new(
          line_item: line_item,
          amount_in_cents: line_item.total
        ).call
      end
    end

    result[:success] = true
    result
  end
end
