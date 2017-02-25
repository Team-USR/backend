require 'faker'

FactoryGirl.define do
  factory :single_choice_question, class: Questions::SingleChoice, parent: :question do
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
end
