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
FactoryBot.define do
  factory :entity, aliases: [:payee, :payor] do
    name { "John Smith" }
    external_id { "123456" }
  end
end
