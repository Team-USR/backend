class RenameUserGroups < ActiveRecord::Migration[5.0]
  def change
    rename_table :user_groups, :groups_users
  end
end
