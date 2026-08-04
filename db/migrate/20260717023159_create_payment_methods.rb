class CreatePaymentMethods < ActiveRecord::Migration[8.1]
  def change
    create_table :payment_methods do |t|
      t.bigint :id
      t.bigint :entity_id
      t.string :payment_processor
      t.timestamps
    end
  end
end
