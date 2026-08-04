class CreateAppliedTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :applied_transactions, id: false do |t|
      t.bigint :id
      t.bigint :transaction_id
      t.bigint :invoice_id
      t.integer :amount_in_cents
      t.timestamps
    end
  end
end
