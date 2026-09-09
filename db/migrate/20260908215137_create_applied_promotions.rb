class CreateAppliedPromotions < ActiveRecord::Migration[8.1]
  def change
    create_table :applied_promotions do |t|
      t.timestamps

      t.bigint :invoice_id
      t.bigint :line_item_id
      t.bigint :adjustment_id
      t.bigint :promotion_id
      t.integer :amount_in_cents
    end
  end
end
