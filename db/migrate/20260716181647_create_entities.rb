class CreateEntities < ActiveRecord::Migration[8.1]
  def change
    create_table :entities do |t|
      t.bigint :id
      t.string :name
      t.string :external_id
      t.timestamps
    end
  end
end
