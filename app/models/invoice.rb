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
class Invoice < ApplicationRecord
  has_many :line_items
  has_many :adjustments
  has_many :applied_transactions
  has_many :transactions, through: :applied_transactions

  belongs_to :payee, class_name: "Entity", foreign_key: :payee_id
end
