require 'faker'

FactoryGirl.define do
  factory :quiz do
    sequence(:title) { |n| "question#{n}" }
  end

  factory :question do
    sequence(:question) { |n| "question#{n}" }
    quiz

    factory :single_choice_question, class: Questions::SingleChoice do
      transient do
        answers_count 0
      end

      after(:create) do |question, evaluator|
        if evaluator.answers_count.positive?
          create(:answer, is_correct: true, question: question)
          (1..evaluator.answers_count).each do
            create(:answer, is_correct: false, question: question)
          end
        end
      end
    end

    factory :multiple_choice_question, class: Questions::MultipleChoice do
      transient do
        answers_count 0
      end

      after(:create) do |question, evaluator|
        if evaluator.answers_count.positive?
          create(:answer, is_correct: true, question: question)
          create(:answer, is_correct: false, question: question) if evaluator.answers_count > 1
          (2..evaluator.answers_count).each do
            create(:answer, is_correct: [true, false].sample, question: question)
          end
        end
      end
    end

    factory :match_question, class: Questions::Match do
      transient do
        pairs_count 0

        after(:create) do |question, evaluator|
          (0..evaluator.pairs_count).each do
            create(:pair, question: question)
          end
        end
      end
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
