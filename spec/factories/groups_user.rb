require 'faker'

FactoryGirl.define do
  factory :groups_user do
    group
    user
  end
end
