require 'faker'

FactoryGirl.define do
  factory :multiple_choice_question, class: Questions::MultipleChoice, parent: :question do
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
end