class AddInvoiceShortcodeConstraints < ActiveRecord::Migration[8.1]
  def change
    add_index :invoices, :shortcode, unique: true
  end
end
