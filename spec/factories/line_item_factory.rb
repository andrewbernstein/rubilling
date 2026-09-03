# == Schema Information
#
# Table name: line_items
#
#  id         :bigint           not null, primary key
#  quantity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  invoice_id :bigint
#  variant_id :bigint
#
FactoryBot.define do
  factory :line_item do
    invoice
    variant
    quantity { 1 }

    trait :with_base_adjustment do
      after(:create) do |instance|
        adjustment = create(:base_adjustment, line_item: instance)
        instance.adjustments << adjustment
        instance.invoice.adjustments << adjustment
      end
    end
  end
end
