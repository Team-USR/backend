class CreateGroupJoinRequest < ActiveRecord::Migration[5.0]
  def change
    create_table :group_join_requests do |t|
      t.belongs_to :group, null: false, index: true
      t.belongs_to :user, null: false
    end
  end
end
