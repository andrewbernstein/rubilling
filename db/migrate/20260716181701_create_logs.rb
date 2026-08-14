class CreateLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :logs do |t|
      t.bigint :parent_log_id
      t.string :action
      t.string :status
      t.json :parameters
      t.text :error
      t.text :error_stack
      t.timestamps
    end
  end
end
