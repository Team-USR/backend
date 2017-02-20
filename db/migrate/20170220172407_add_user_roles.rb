class AddUserRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name, null: false
    end

    create_join_table :users, :roles
  end
end
