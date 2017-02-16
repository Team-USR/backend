class CreateMixQuestion < ActiveRecord::Migration[5.0]
  def change
    create_table :sentence do |t|
      t.string :text
      t.timestamps
      t.references :question, polymorphic: true, index: true, null: false
      t.boolean :is_main
    end
  end
end
