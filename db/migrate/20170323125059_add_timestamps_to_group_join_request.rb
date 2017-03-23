class AddTimestampsToGroupJoinRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :group_join_requests, :created_at, :datetime, default: DateTime.now, null: false
    add_column :group_join_requests, :updated_at, :datetime
  end
end
