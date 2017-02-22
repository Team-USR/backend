class AddHints < ActiveRecord::Migration[5.0]
  def change
    create_table :hints do |t|
      t.string :hint_text
      t.timestamps
      t.belongs_to :gap, index: true, polymorphic: true, null: true
    end
  end
end
