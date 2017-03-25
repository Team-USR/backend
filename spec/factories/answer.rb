require 'faker'

FactoryGirl.define do
  factory :answer do
    sequence(:answer) { |n| "answer#{n}" }
    is_correct Faker::Boolean.boolean

    after(:create) do |answer|
      if answer.question.nil?
        answer.question = create(:single_choice_question)
      end
    end
  end
end
