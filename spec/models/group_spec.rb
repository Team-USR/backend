require 'rails_helper'

RSpec.describe Group, type: :model do
  subject { build(:group) }

  it { should validate_presence_of(:name) }
end
