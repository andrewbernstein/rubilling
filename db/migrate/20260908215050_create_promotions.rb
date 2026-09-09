class CreatePromotions < ActiveRecord::Migration[8.1]
  def change
    create_table :promotions do |t|
      t.timestamps

      t.string :description
      t.integer :amount_in_cents # a promotion should not have both an amount_in_cents and a percentage
      t.integer :percentage
      t.bigint :variant_id
      t.string :promotion_type
      t.datetime :start_at
      t.datetime :end_at
    end
  end
end
