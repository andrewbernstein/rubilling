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
class Invoice < ApplicationRecord
  # remove b, g, l, and o because they could get confused for 6, 9, 1, and 0 potentially
  # leaving 32 potential shortcode characters
  SHORTCODE_CHARACTERS = %w[
    0 1 2 3 4 5 6 7 8 9 a c d e f h i j k m n p q r s t u v w x y z
  ]

  SHORTCODE_LENGTH = 8 # assume 32^8 (2^40) shortcode possibilities are enough?

  has_many :line_items
  has_many :adjustments
  has_many :applied_transactions
  has_many :transactions, through: :applied_transactions

  belongs_to :payee, class_name: "Entity", foreign_key: :payee_id, optional: true

  validates :shortcode, uniqueness: true

  before_create :generate_shortcode

  # this borrows logic from url shorteners to generate a unique shortcode for each invoice
  # theoretically this can fail with enough load or simply bad luck, so the service creating invoices
  # should likely loop to ensure that the invoice saves correctly
  # with enough failures, increase the length of the shortcode to reduce collisions
  def generate_shortcode
    loop do
      self.shortcode = SHORTCODE_CHARACTERS.sample(SHORTCODE_LENGTH)
      break unless Invoice.exists?(shortcode: self.shortcode)
    end
  end
end
