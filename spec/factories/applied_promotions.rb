# == Schema Information
#
# Table name: applied_promotions
#
#  id              :bigint           not null, primary key
#  amount_in_cents :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  adjustment_id   :bigint
#  invoice_id      :bigint
#  line_item_id    :bigint
#  promotion_id    :bigint
#
FactoryBot.define do
  factory :applied_promotion do
    # not implemented yet
  end
end
