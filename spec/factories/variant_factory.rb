# == Schema Information
#
# Table name: variants
#
#  id              :bigint           not null, primary key
#  amount_in_cents :integer
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  product_id      :bigint
#
# Indexes
#
#  index_variants_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :variant do
    product
    name { |n| "blue test product#{n}" }
    amount_in_cents { 1000 }
  end
end
