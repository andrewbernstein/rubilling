class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.bigint :id
      t.integer :amount_in_cents
      t.bigint :payment_method_id
      t.timestamps
    end
  end
end
