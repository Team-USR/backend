require 'rails_helper'

describe GroupInviteJob, type: :job do
  let(:group) { create(:group) }

  it "creates a GroupInvite" do
    expect { subject.perform(group, "test") }
      .to change { GroupInvite.count }.by(1)

    expect(GroupInvite.last.email).to eq("test")
    expect(GroupInvite.last.group).to eq(group)
  end
end
