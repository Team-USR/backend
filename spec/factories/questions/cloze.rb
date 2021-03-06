require 'faker'

FactoryGirl.define do
  factory :cloze_question, class: Questions::Cloze, parent: :question do
    transient do
      gap_count 1
    end

    after(:build) do |question, evaluator|
      if evaluator.gap_count.positive?
        words = Faker::Lorem.words(evaluator.gap_count)
        gaps = (1..evaluator.gap_count).map { |i| "$(#{i})" }
        sentence = words.zip(gaps).flatten.join(" ")
        question.cloze_sentence = create(:cloze_sentence, text: sentence, question: question)
        (1..evaluator.gap_count).each do
          question.gaps << create(:gap, question: question)
        end
      else
        raise "Gap count must be at least 1"
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
