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
FactoryBot.define do
  factory :adjustment do
    invoice
    line_item

    # the base cost of the Line Item, effectively the price on the menu
    factory :base_adjustment do
      adjustment_type { Adjustment::BASE_TYPE }
      amount_in_cents { 1000 }
    end

    # a tax for the Line Item, there can be more than one tax Adjustment
    factory :tax_adjustment do
      adjustment_type { Adjustment::TAX_TYPE }
      amount_in_cents { 100 }
    end

    # a credit applied to the line item saying you don't owe this money anymore after a refund
    # or due to customer service (or applicable group) applying a credit to the invoice
    # should customer service credits have an applied transaction? probably, since there is a financial impact
    factory :credit_adjustment do
      adjustment_type { Adjustment::CREDIT_TYPE }
      applied_transaction { association :applied_transaction, invoice: invoice }
      amount_in_cents { -1100 }
    end

    # a discount to the line item, usually from a coupon or discount code
    factory :discount_adjustment do
      adjustment_type { Adjustment::DISCOUNT_TYPE }
      amount_in_cents { -500 }
    end

    # a payment from the customer, reducing the amount owed on the Invoice/Line Item
    # must have an Applied Transaction to link the payment Adjustment to the payment Transaction
    factory :payment_adjustment do
      adjustment_type { Adjustment::PAYMENT_TYPE }
      applied_transaction { association :applied_transaction, invoice: invoice }
      amount_in_cents { -1100 }
    end

    # registration of a refund to the customer on the Invoice/Line Item
    # must have an Applied Transaction to link the refund Adjustment to the refund Transaction
    # if you do not want the payor to still owe this money on the Invoice, you must add a matching credit Adjustment
    factory :refund_adjustment do
      adjustment_type { Adjustment::REFUND_TYPE }
      applied_transaction { association :applied_transaction, invoice: invoice }
      amount_in_cents { 1100 }
    end

    # registration of a payment to a service provider of the invoice in a two-sided marketplace
    # this mechanism may be easier to represent through a pair of inverted invoices, so payout type might get deprecated
    factory :payout_adjustment do
      adjustment_type { Adjustment::PAYOUT_TYPE }
      applied_transaction { association :applied_transaction, invoice: invoice }
      amount_in_cents { 1000 }
    end
  end
end
