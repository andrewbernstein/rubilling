# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#
# Indexes
#
#  index_products_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :product do
    name { |n| "test product#{n}" }
  end
end
