# == Schema Information
#
# Table name: applied_transactions
#
#  id              :bigint           not null, primary key
#  amount_in_cents :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  invoice_id      :bigint
#  transaction_id  :bigint
#
class AppliedTransaction < ApplicationRecord
  belongs_to :invoice
  belongs_to :payment_transaction, class_name: "Transaction", foreign_key: :transaction_id
end
