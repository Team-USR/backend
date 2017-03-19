require 'rails_helper'

RSpec.describe CrossRow, type: :model do
  subject { build(:cross_row) }

  it { should validate_presence_of(:row) }

  it { should allow_value('*').for(:row) }
  it { should allow_value('**').for(:row) }
  it { should allow_value('*a*').for(:row) }
  it { should allow_value('*ab*y').for(:row) }
  it { should allow_value('*ab*z*').for(:row) }
  it { should allow_value('*ab*z**').for(:row) }
  it { should allow_value('*a*b*z**').for(:row) }

  it { should_not allow_value('').for(:row) }
  it { should_not allow_value('1').for(:row) }
  it { should_not allow_value('a1').for(:row) }
  it { should_not allow_value('*1').for(:row) }
end
