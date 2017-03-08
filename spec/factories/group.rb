require 'faker'

FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| "group#{n}" }
    user
  end
end
