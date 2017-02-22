RSpec.describe Questions::MultipleChoice, type: :model do
  subject { FactoryGirl.create(:multiple_choice_question, :with_answers) }

  it { should validate_presence_of(:question) }
end
