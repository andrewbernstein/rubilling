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
FactoryBot.define do
  factory :variant do
    product
    name { "blue test product" }
    amount_in_cents { 1000 }
  end
end
