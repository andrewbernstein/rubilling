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
class Adjustment < ApplicationRecord
  BASE_TYPE = "base"
  CREDIT_TYPE = "credit"
  DISCOUNT_TYPE = "discount"
  PAYMENT_TYPE = "payment"
  PAYOUT_TYPE = "payout"
  REFUND_TYPE = "refund"
  TAX_TYPE = "tax"

  ADJUSTMENT_TYPES = [
    BASE_TYPE,
    CREDIT_TYPE,
    DISCOUNT_TYPE,
    PAYMENT_TYPE,
    PAYOUT_TYPE,
    REFUND_TYPE,
    TAX_TYPE
  ]

  belongs_to :invoice
  belongs_to :line_item
  belongs_to :applied_transaction, optional: true
end
