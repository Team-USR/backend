require 'faker'

FactoryGirl.define do
  factory :group_join_request do
    group
    user
  end
end
