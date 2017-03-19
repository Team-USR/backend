require 'faker'

FactoryGirl.define do
  factory :question do
    sequence(:question) { |n| "question#{n}" }
    quiz
    points 1
  end
end
