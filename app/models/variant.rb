# == Schema Information
#
# Table name: variants
#
#  id              :bigint           not null, primary key
#  amount_in_cents :integer
#  name            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  product_id      :bigint
#
# Indexes
#
#  index_variants_on_name  (name) UNIQUE
#
class Variant < ApplicationRecord
  belongs_to :product

  validates :name, presence: true, uniqueness: true
  validates :amount_in_cents, presence: true
end
