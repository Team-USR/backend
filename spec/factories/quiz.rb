# FactoryGirl.define do
#   factory :quiz do
#     sequence(:title) { |n| "question#{n}" }
#   end
#
#   factory :question do
#     sequence(:question) { |n| "question#{n}" }
#     quiz FactoryGirl.create(:quiz)
#     trait :with_answers do
#       after(:create) do |question|
#         create(:answer, is_correct: true, question: question)
#         create(:answer, is_correct: false, question: question)
#         create(:answer, is_correct: false, question: question)
#       end
#     end
#   end
#
#   factory :answer do
#     sequence(:answer) { |n| "answer#{n}" }
#     is_correct false
#     question FactoryGirl.create(:question)
#   end
# end
