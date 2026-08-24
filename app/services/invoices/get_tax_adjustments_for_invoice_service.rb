class Invoices::GetTaxAdjustmentsForInvoiceService
  prepend ServiceMonitoring

  def initialize(invoice:)
    @invoice = invoice
  end

  def call
    # for now, this is going to be a dummy service that stands in the place of actually
    # calling an external tax service to get tax information for the invoice
    # it will be stubbed for specs, and filled in (at least more so) once we want to
    # explore how to integrate with external tax services more
    # it's likely that there will be a "get estimated taxes" service, "get real taxes" service,
    # and services for committing, revoking, and adjusting the real taxes once an invoice is charged
    # return format (at least for now) is an array of line ids and tax amounts for each
    # tax adjustment to be created for each line
  end
end
