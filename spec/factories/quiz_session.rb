require 'faker'

FactoryGirl.define do
  factory :quiz_session do
    quiz
    user
    state "in_progress"
  end
end
