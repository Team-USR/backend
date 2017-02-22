class RenameUsersGroups < ActiveRecord::Migration[5.0]
  def change
      rename_table :groups_users, :user_groups
  end
end
