require 'faker'

FactoryGirl.define do
  factory :question do
    sequence(:question) { |n| "question#{n}" }
    quiz
  end
end
