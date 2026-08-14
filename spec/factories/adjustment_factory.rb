# == Schema Information
#
# Table name: adjustments
#
#  id                     :bigint           not null, primary key
#  amount_in_cents        :integer
#  type                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  applied_transaction_id :bigint
#  invoice_id             :bigint
#  line_item_id           :bigint
#
FactoryBot.define do
  factory :adjustment do
  end
end
