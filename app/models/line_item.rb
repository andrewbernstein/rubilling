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
class LineItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :variant

  has_many :adjustments

  # each line item should only have a single base adjustment!
  # if you ever find yourself wanting more than one base adjustment,
  # you probably want more than one line instead!
  def base_adjustment
    adjustments.where(adjustment_type: Adjustment::BASE_TYPE).first
  end

  def total
    adjustments.sum(:amount_in_cents)
  end
end
