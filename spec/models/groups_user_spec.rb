require 'rails_helper'

RSpec.describe GroupsUser, type: :model do
  subject { build(:groups_user) }

  it { should validate_uniqueness_of(:user_id).scoped_to(:group_id) }
end
