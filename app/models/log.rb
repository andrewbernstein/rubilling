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
class Log < ApplicationRecord
  ATTEMPTED = "attempted"
  ERRORED = "errored"
  FAILED_VALIDATION = "failed_validation"
  SUCCESSFUL = "successful"

  STATUSES = [
    ATTEMPTED,
    ERRORED,
    FAILED_VALIDATION,
    SUCCESSFUL
  ]
end
