require 'rails_helper'

# == Schema Information
#
# Table name: promotions
#
#  id              :bigint           not null, primary key
#  amount_in_cents :integer
#  description     :string
#  end_at          :datetime
#  percentage      :integer
#  promotion_type  :string
#  start_at        :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  variant_id      :bigint
#
RSpec.describe Promotion, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
