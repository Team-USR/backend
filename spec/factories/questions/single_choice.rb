require 'faker'

FactoryGirl.define do
  factory :single_choice_question, class: Questions::SingleChoice, parent: :question do
    transient do
      answers_count 1
    end

    after(:build) do |question, evaluator|
      if evaluator.answers_count.positive?
        question.answers << build(:answer, is_correct: true)
        (2..evaluator.answers_count).each do
          question.answers << build(:answer, is_correct: false)
        end
      end
    end
  end
end
