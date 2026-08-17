require "rails_helper"

# == Schema Information
#
# Table name: adjustments
#
#  id                     :bigint           not null, primary key
#  adjustment_type        :string
#  amount_in_cents        :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  applied_transaction_id :bigint
#  invoice_id             :bigint
#  line_item_id           :bigint
#
class AdjustmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
