require "rails_helper"

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
describe LineItem do
end
