require 'faker'

FactoryGirl.define do
  factory :cross_question, class: Questions::Cross, parent: :question do
    factory :cross_question_with_data do
      after(:build) do |question|
        question.metadata = create(:cross_metadata, height: 3, width: 3)

        question.rows << create(:cross_row, row: "ab*")
        question.rows << create(:cross_row, row: "c*d")
        question.rows << create(:cross_row, row: "e*f")

        question.hints << create(:cross_hint, row: 0, column: 0, across: true)
        question.hints << create(:cross_hint, row: 1, column: 0, across: true)
        question.hints << create(:cross_hint, row: 1, column: 2, across: true)
        question.hints << create(:cross_hint, row: 2, column: 0, across: true)
        question.hints << create(:cross_hint, row: 2, column: 2, across: true)

        question.hints << create(:cross_hint, row: 0, column: 0, across: false)
        question.hints << create(:cross_hint, row: 0, column: 1, across: false)
        question.hints << create(:cross_hint, row: 1, column: 2, across: false)
      end
    end
  end

  factory :cross_metadata do
    association :question, factory: :cross_question
    height 8
    width 9
  end

  factory :cross_row do
    association :question, factory: :cross_question
    row '**ab**cc'
  end

  factory :cross_hint do
    association :question, factory: :cross_question
    hint { Faker::Lorem.word }
    row { Faker::Number.between(1, 10) }
    column { Faker::Number.between(1, 10) }
    across { Faker::Boolean.boolean }
  end
end
