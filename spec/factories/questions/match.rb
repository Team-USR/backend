require 'faker'

FactoryGirl.define do
  factory :match_question, class: Questions::Match, parent: :question do
    transient do
      pairs_count 0
    end

    after(:create) do |question, evaluator|
      (0..evaluator.pairs_count).each do
        create(:pair, question: question)
      end
    end
  end

  factory :pair do
    association :question, factory: :match_question
    left_choice Faker::Lorem.word
    right_choice Faker::Lorem.word
  end
end
