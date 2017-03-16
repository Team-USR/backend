require 'faker'

FactoryGirl.define do
  factory :match_default do
    sequence(:default_text) { |n| "default_text#{n}" }
    association :question, factory: :match_question
  end
end
