class ImproveGroupsUserRelation < ActiveRecord::Migration[5.0]
  def change
    add_column :groups_users, :role, :string, null: false, default: "student"
    Group.all.each do |group|
      GroupsUser.create!(
        group: group,
        user: group.user,
        role: "admin"
      )
    end

    remove_column :groups, :user_id, :string
  end
end
