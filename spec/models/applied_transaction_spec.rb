require "rails_helper"

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
describe AppliedTransaction do

end
