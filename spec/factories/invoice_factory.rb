# == Schema Information
#
# Table name: invoices
#
#  id                :bigint           not null, primary key
#  shortcode         :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  external_id       :string
#  parent_invoice_id :bigint
#  payee_id          :bigint
#
# Indexes
#
#  index_invoices_on_shortcode  (shortcode) UNIQUE
#
FactoryBot.define do
  factory :invoice do
    payee
  end

  trait :with_line_item_with_base_adjustment do
    after :create do |instance|
      line_item = create(:line_item, :with_base_adjustment, invoice: instance)
      instance.line_items << line_item
    end
  end
end
