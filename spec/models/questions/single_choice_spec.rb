require 'rails_helper'
require 'factory_girl_rails'

RSpec.describe Questions::SingleChoice, type: :model do
  subject { FactoryGirl.create(:single_choice_question, :with_answers) }

  describe '#check_answer' do
    it 'returns false if the id of the answer is not the correct one' do
      expect(subject.check_answer(1)).to eq(true)
    end

    it 'returns true if the id of the answer is the correct one' do
      expect(subject.check_answer(0)).to eq(false)
    end
  end
end
