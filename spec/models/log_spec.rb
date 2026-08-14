require "rails_helper"

# == Schema Information
#
# Table name: logs
#
#  id            :bigint           not null, primary key
#  action        :string
#  error         :text
#  error_stack   :text
#  parameters    :json
#  status        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  parent_log_id :bigint
#
class LogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
