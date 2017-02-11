class CreatePairChoice < ActiveRecord::Migration[5.0]
  def change
    create_table :pair_choices do |t|
      t.string :title
      t.string :uuid
      t.belongs_to :pair
    end

    remove_column :pairs, :left_choice, :string
    remove_column :pairs, :right_choice, :string

    add_reference :pairs, :left_choice, foreign_key: { to_table: :pair_choices }, index: true
    add_reference :pairs, :right_choice, foreign_key: { to_table: :pair_choices }, index: true
  end
end
