class CreateLineItems < ActiveRecord::Migration[8.1]
  def change
    create_table :line_items, id: false  do |t|
      t.bigint :id
      t.bigint :invoice_id
      t.bigint :variant_id
      t.integer :quantity
      t.timestamps
    end
  end
end
