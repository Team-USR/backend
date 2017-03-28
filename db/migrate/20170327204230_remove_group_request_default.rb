class RemoveGroupRequestDefault < ActiveRecord::Migration[5.0]
  def change
    change_column_default :group_join_requests, :created_at, nil
  end
end
