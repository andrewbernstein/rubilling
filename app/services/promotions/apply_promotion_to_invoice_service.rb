class Promotions::ApplyPromotionToInvoiceService
  prepend ServiceMonitoring

  def initialize(invoice:, promotion:)
    @invoice = invoice
    @promotion = promotion
  end

  def call
    # not implemented yet
  end
end
