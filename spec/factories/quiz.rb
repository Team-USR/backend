require 'faker'

FactoryGirl.define do
  factory :quiz do
    sequence(:title) { |n| "question#{n}" }
  end

  factory :single_choice_question, class: Questions::SingleChoice do
    sequence(:question) { |n| "question#{n}" }
    quiz
    trait :with_answers do
      after(:create) do |question|
        create(:answer, is_correct: true, question: question)
        create(:answer, is_correct: false, question: question)
        create(:answer, is_correct: false, question: question)
      end
    end
  end

  factory :match_question, class: Questions::Match do
    sequence(:question) { |n| "question#{n}" }
    quiz
  end

  factory :answer do
    sequence(:answer) { |n| "answer#{n}" }
    is_correct false
    question FactoryGirl.create(:single_choice_question)
  end

  factory :pair do
    question FactoryGirl.create(:match_question)
    left_choice Faker::Lorem.word
    right_choice Faker::Lorem.word
  end
end
