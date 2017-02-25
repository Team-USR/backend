require 'faker'

FactoryGirl.define do
  factory :answer do
    sequence(:answer) { |n| "answer#{n}" }
    is_correct Faker::Boolean.boolean
    association :question, factory: :single_choice_question
  end
end
