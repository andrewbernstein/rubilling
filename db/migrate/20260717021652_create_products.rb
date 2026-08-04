class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.bigint :id
      t.string :name
      t.timestamps
    end
  end
end
