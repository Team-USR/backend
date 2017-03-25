require 'faker'

FactoryGirl.define do
  factory :multiple_choice_question, class: Questions::MultipleChoice, parent: :question do
    transient do
      answers_count 1
    end

    after(:build) do |question, evaluator|
      if evaluator.answers_count.positive?
        question.answers << build(:answer, is_correct: true)
        question.answers << build(:answer, is_correct: false) if evaluator.answers_count > 1
        (3..evaluator.answers_count).each do
          question.answers << build(:answer, is_correct: [true, false].sample)
        end
      end
    end
  end
end
