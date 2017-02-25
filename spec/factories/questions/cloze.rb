require 'faker'

FactoryGirl.define do
  factory :cloze_question, class: Questions::Cloze, parent: :question do
    transient do
      gap_count 0
    end

    after(:create) do |question, evaluator|
      if evaluator.gap_count.positive?
        words = Faker::Lorem.words(evaluator.gap_count)
        gaps = (1..evaluator.gap_count).map { |i| "$(#{i})" }
        sentence = words.zip(gaps).flatten.join(" ")
        create(:cloze_sentence, question: question, text: sentence)
        (1..evaluator.gap_count).each do
          create(:gap, question: question)
        end
      end
    end
  end

  factory :gap do
    gap_text Faker::Lorem.word
    association :question, factory: :cloze_question

    after(:build) do |gap|
      gap.hint ||= build(:hint, gap: gap)
    end
  end

  factory :hint do
    hint_text Faker::Lorem.sentence
    gap
  end

  factory :cloze_sentence do
    text Faker::Lorem.sentence
    association :question, factory: :cloze_question
  end
end
