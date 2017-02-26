require 'rails_helper'

RSpec.describe Gap, type: :model do
  subject { build(:gap) }

  it { should validate_presence_of(:gap_text) }
end
