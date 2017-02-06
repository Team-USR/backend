# require 'rails_helper'
# require 'factory_girl_rails'
#
# RSpec.describe Question, type: :model do
#   subject { FactoryGirl.create(:question, :with_answers) }
#
#   describe '#check_answer' do
#     it 'returns false if the id of the answer is not the correct one' do
#       expect(subject.check_answer(1)).to eq(true)
#     end
#
#     it 'returns true if the id of the answer is the correct one' do
#       expect(subject.check_answer(0)).to eq(false)
#     end
#   end
#
#   it { should validate_presence_of(:question) }
# end
