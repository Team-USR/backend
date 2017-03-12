class AddPointsToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :points, :float, default: 0.0, null: false
  end
end
