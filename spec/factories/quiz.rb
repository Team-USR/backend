require 'faker'

FactoryGirl.define do
  factory :quiz do
    sequence(:title) { |n| "question#{n}" }
  end

  factory :question do
    sequence(:question) { |n| "question#{n}" }
    quiz

    factory :single_choice_question, class: Questions::SingleChoice do
      trait :with_answers do
        after(:create) do |question|
          create(:answer, is_correct: true, question: question)
          create(:answer, is_correct: false, question: question)
          create(:answer, is_correct: false, question: question)
        end
      end
    end

    factory :multiple_choice_question, class: Questions::MultipleChoice do
      trait :with_answers do
        after(:create) do |question|
          create(:answer, is_correct: true, question: question)
          create(:answer, is_correct: true, question: question)
          create(:answer, is_correct: false, question: question)
        end
      end
    end

    factory :match_question, class: Questions::Match do
    end
  end

  factory :answer do
    sequence(:answer) { |n| "answer#{n}" }
    is_correct false
    association :question, factory: :single_choice_question
  end

  factory :pair do
    association :question, factory: :match_question
    left_choice Faker::Lorem.word
    right_choice Faker::Lorem.word
  end
end
