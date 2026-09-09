require 'rails_helper'

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
RSpec.describe AppliedPromotion, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
