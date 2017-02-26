require 'rails_helper'

RSpec.describe Answer, type: :model do
  subject { build(:answer) }

  it { should validate_presence_of(:answer) }
  it { should_not allow_value(nil).for(:is_correct) }
end
