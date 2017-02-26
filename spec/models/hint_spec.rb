require 'rails_helper'

RSpec.describe Hint, type: :model do
  subject { build(:hint) }

  it { should validate_presence_of(:hint_text) }
end
