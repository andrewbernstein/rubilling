class Invoices::CreateInvoiceService
  prepend ServiceMonitoring

  def initialize(payee:, external_id: nil, parent_invoice: nil)
    @payee = payee
    @external_id = external_id
    @parent_invoice = parent_invoice
  end

  def call
    invoice = Invoice.new(
      payee: @payee,
      external_id: external_id,
      parent_invoice: parent_invoice
    )
    invoice.save!

    invoice
  end
end
