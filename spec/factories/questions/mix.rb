require 'faker'

FactoryGirl.define do
  factory :mix_question, class: Questions::Mix, parent: :question do
    transient do
      sentence_count 0
      words_count 5
    end

    after(:create) do |question, evaluator|
      if evaluator.sentence_count.positive?
        words = Faker::Lorem.words(evaluator.words_count)

        sentences = words.permutation(words.count).take(evaluator.sentence_count)
        create(
          :sentence,
          question: question,
          text: sentences.first.join(" "),
          is_main: true
        )
        sentences.drop(1).each do |sentence|
          create(
            :sentence,
            question: question,
            text: sentence.join(" "),
            is_main: false
          )
        end
      end
    end
  end

  factory :sentence do
    association :question, factory: :match_question
    text Faker::Lorem.sentence
    is_main Faker::Boolean.boolean
  end
end
