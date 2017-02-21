require 'rails_helper'
require 'factory_girl_rails'

RSpec.describe Question, type: :model do
  subject { build(:question) }

  it { should validate_presence_of(:question) }
end
