require 'rails_helper'

RSpec.describe CrossHint, type: :model do
  subject { build(:cross_hint) }

  it { should validate_presence_of(:row) }
  it { should validate_presence_of(:column) }
  it { should validate_presence_of(:hint) }

  it { should_not allow_value(nil).for(:across) }
end
