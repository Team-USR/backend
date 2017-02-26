require 'rails_helper'

RSpec.describe Sentence, type: :model do
  subject { build(:sentence) }

  it { should validate_presence_of(:text) }
  it { should_not allow_value(nil).for(:is_main) }
end
