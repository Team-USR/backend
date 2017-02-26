require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { build(:question) }

  it { should validate_presence_of(:question) }
end
