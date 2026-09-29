class AddCategoryToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :category_id, :bigint
  end
end
