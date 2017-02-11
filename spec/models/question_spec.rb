require 'rails_helper'
require 'factory_girl_rails'

RSpec.describe Question, type: :model do
  subject { FactoryGirl.create(:single_choice_question, :with_answers) }

  it { should validate_presence_of(:question) }
end
