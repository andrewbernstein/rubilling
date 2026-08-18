require "rails_helper"

# == Schema Information
#
# Table name: invoices
#
#  id                :bigint           not null, primary key
#  shortcode         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  external_id       :string
#  parent_invoice_id :bigint
#  payee_id          :bigint
#
# Indexes
#
#  index_invoices_on_shortcode  (shortcode) UNIQUE
#
describe Invoice do
  describe "#generate_shortcode" do
    context "shortcode invalid characters" do
      [ "b", "g", "l", "o" ].each do |char|
        it "does not contain #{char}" do
          10.times do
            invoice = Invoice.new
            invoice.save!
            expect(invoice.shortcode.index(char)).to be_nil
          end
        end
      end
    end
  end
end
