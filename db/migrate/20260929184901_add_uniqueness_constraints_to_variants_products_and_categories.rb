class AddUniquenessConstraintsToVariantsProductsAndCategories < ActiveRecord::Migration[8.1]
  def change
    add_index :categories, :name, unique: true
    add_index :products, :name, unique: true
    add_index :variants, :name, unique: true
  end
end
