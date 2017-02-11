class CreatePairTable < ActiveRecord::Migration[5.0]
  def change
    create_table :pairs do |t|
      t.timestamps
      t.references :question, polymorphic: true, index: true, null: false
      t.string :left_choice
      t.string :right_choice
    end
  end
end
