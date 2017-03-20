require 'faker'

FactoryGirl.define do
  factory :group_invite do
    group
    email { Faker::Internet.email }
  end
end
