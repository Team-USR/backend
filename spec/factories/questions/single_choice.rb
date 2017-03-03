require 'faker'

FactoryGirl.define do
  factory :single_choice_question, class: Questions::SingleChoice, parent: :question do
    transient do
      answers_count 0
    end

    after(:create) do |question, evaluator|
      if evaluator.answers_count.positive?
        question.answers << create(:answer, is_correct: true)
        (2..evaluator.answers_count).each do
          question.answers << create(:answer, is_correct: false)
        end
      end
    end
  end
end
