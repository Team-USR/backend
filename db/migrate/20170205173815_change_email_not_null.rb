class ChangeEmailNotNull < ActiveRecord::Migration[5.0]
  def change
    change_column_null :users, :email, false
    change_column_null :users, :name, false
    change_column_null :users, :password_digest, false
  end
end
