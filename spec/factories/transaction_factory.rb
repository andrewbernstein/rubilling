# == Schema Information
#
# Table name: transactions
#
#  id                :bigint           not null, primary key
#  amount_in_cents   :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  payment_method_id :bigint
#
FactoryBot.define do
  factory :transaction do
  end
end
