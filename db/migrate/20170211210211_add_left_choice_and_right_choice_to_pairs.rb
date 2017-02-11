class AddLeftChoiceAndRightChoiceToPairs < ActiveRecord::Migration[5.0]
  def change
    add_column :pairs, :left_choice, :string, null: false, default: ""
    add_column :pairs, :left_choice_uuid, :string, null: false, default: ""
    add_column :pairs, :right_choice, :string, null: false, default: ""
    add_column :pairs, :right_choice_uuid, :string, null: false, default: ""
  end
end
