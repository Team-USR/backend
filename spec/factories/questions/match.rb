require 'faker'

FactoryGirl.define do
  factory :match_question, class: Questions::Match, parent: :question do
    association :match_default

    transient do
      pairs_count 0
    end

    after(:create) do |question, evaluator|
      (1..evaluator.pairs_count).each do
        question.pairs << create(:pair)
      end
    end
  end

  factory :pair do
    association :question, factory: :match_question
    left_choice Faker::Lorem.word
    right_choice Faker::Lorem.word
  end

  factory :match_default do
    sequence(:default_text) { |n| "default_text#{n}" }
  end
end
