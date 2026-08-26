# == Schema Information
#
# Table name: payment_methods
#
#  id                :bigint           not null, primary key
#  payment_processor :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  entity_id         :bigint
#
class PaymentMethod < ApplicationRecord
  belongs_to :entity
end
