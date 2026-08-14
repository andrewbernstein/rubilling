class CreateLineItems < ActiveRecord::Migration[8.1]
  def change
    create_table :line_items  do |t|
      t.bigint :invoice_id
      t.bigint :variant_id
      t.integer :quantity
      t.timestamps
    end
  end
end
