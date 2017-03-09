class AddUserIdToGroups < ActiveRecord::Migration[5.0]
  def change
    add_reference :groups, :user
    add_foreign_key :groups, :users
  end
end
