class CreateGroupInvite < ActiveRecord::Migration[5.0]
  def change
    create_table :group_invites do |t|
      t.belongs_to :group, null: false
      t.string :email, index: true, null: false
    end
  end
end
