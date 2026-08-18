require "rails_helper"

describe Invoices::CreateInvoiceService do
  describe "#call" do
    let(:payee) { nil }
    let(:external_id) { nil }
    let(:parent_invoice) { nil }

    let(:result) do
      described_class.new(
        payee: payee,
        external_id: external_id,
        parent_invoice: parent_invoice
      ).call
    end

    context "with default parameters" do
      it "creates a new invoice" do
        result
        expect(Invoice.count).to eq(1)
        invoice = Invoice.first
        expect(invoice.payee).to eq(payee)
        expect(invoice.external_id).to eq(external_id)
        expect(invoice.parent_invoice).to eq(parent_invoice)
      end
    end

    context "with payee, external_id, and parent_invoice provided" do
      let(:payee) { create(:entity) }
      let(:external_id) { '1234567' }
      let(:parent_invoice) { create(:invoice) }

      it "creates a new invoice" do
        result
        expect(Invoice.count).to eq(2)
        invoice = Invoice.last
        expect(invoice.payee).to eq(payee)
        expect(invoice.external_id).to eq(external_id)
        expect(invoice.parent_invoice).to eq(parent_invoice)
      end
    end


    context "log creation" do
      it "creates a log for the service call" do
        result
        expect(Log.count).to eq(1)
        log = Log.first
        expect(log.action).to eq('Invoices::CreateInvoiceService')
        expect(log.status).to eq('successful')
      end
    end
  end
end
