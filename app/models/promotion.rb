# == Schema Information
#
# Table name: promotions
#
#  id              :bigint           not null, primary key
#  amount_in_cents :integer
#  description     :string
#  end_at          :datetime
#  percentage      :integer
#  promotion_type  :string
#  start_at        :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  category_id     :bigint
#  product_id      :bigint
#  variant_id      :bigint
#
class Promotion < ApplicationRecord
  FLAT_DISCOUNT_TYPE = "flat_discount"
  PERCENTAGE_DISCOUNT_TYPE = "percentage_discount"

  has_many :applied_promotions

  # each promotion should have only one of variant, product, or category that the promotion applies to.
  # if you want a promotion to apply to more than one, you'll have to duplicate the promotion
  has_one :variant
  has_one :product
  has_one :category
end
