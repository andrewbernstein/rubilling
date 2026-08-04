class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices, id: false do |t|
      t.bigint :id
      t.string :shortcode
      t.bigint :parent_invoice_id
      t.bigint :payee_id
      t.string :external_id
      t.timestamps
    end
  end
end
