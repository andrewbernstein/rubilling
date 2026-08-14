class CreateInvoiceService
  prepend ServiceMonitoring
  
  def initialize(payee:, external_id: nil, parent_invoice: nil)
    @payee = payee
    @external_id = external_id
    @parent_invoice = parent_invoice
  end

  def call
    Invoice.new(
      payee: @payee,
      external_id: external_id,
      parent_invoice: parent_invoice
    ).save!
  end
end
