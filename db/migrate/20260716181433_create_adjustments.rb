class CreateAdjustments < ActiveRecord::Migration[8.1]
  def change
    create_table :adjustments do |t|
      t.bigint :invoice_id
      t.bigint :line_item_id # technically not necessary, but could be very helpful
      t.bigint :applied_transaction_id
      t.integer :amount_in_cents
      t.string :type
      t.timestamps
    end
  end
end
