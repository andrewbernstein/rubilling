# == Schema Information
#
# Table name: entities
#
#  id          :bigint           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :string
#
class Entity < ApplicationRecord
  has_many :invoices, as: :payee, foreign_key: "payee_id"
  has_many :transactions, as: :payee
  has_many :transactions, as: :payor
  has_many :payment_methods
end
