class AddGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.timestamps
    end

    create_join_table :users, :groups
    
  end
end
