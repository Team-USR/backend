class RemovePairChoice < ActiveRecord::Migration[5.0]
  def change
    remove_reference(:pairs, :left_choice, index: true, null: false)
    remove_reference(:pairs, :right_choice, index: true, null: false)
    drop_table :pair_choices
  end
end
