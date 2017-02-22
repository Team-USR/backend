class AddGap < ActiveRecord::Migration[5.0]
  def change
    create_table :gaps do |t|
      t.string :gap_text
      t.timestamps
      t.references :question, polymorphic: true, index: true, null:false
    end
  end
end
