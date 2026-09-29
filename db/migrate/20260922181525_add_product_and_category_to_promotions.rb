class AddProductAndCategoryToPromotions < ActiveRecord::Migration[8.1]
  def change
    add_column :promotions, :product_id, :bigint
    add_column :promotions, :category_id, :bigint
  end
end
