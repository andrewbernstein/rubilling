class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices do |t|
      t.bigint :id
      t.string :shortcode
      t.bigint :payee_id
      t.timestamps
    end
  end
end
