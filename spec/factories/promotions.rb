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
#  variant_id      :bigint
#
FactoryBot.define do
  factory :promotion do
    # not implemented yet
  end
end
