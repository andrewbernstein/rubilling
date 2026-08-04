class CreateVariants < ActiveRecord::Migration[8.1]
  def change
    create_table :variants, id: false do |t|
      t.bigint :id
      t.bigint :product_id
      t.integer :amount_in_cents
      t.string :name
      t.timestamps
    end
  end
end
