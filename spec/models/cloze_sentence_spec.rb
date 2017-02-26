require 'rails_helper'

RSpec.describe ClozeSentence, type: :model do
  subject { build(:cloze_sentence) }

  it { should validate_presence_of(:text) }
end
