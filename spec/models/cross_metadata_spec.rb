require 'rails_helper'

RSpec.describe CrossMetadata, type: :model do
  subject { build(:cross_metadata) }

  it { should validate_presence_of(:width) }
  it { should validate_presence_of(:height) }
end
