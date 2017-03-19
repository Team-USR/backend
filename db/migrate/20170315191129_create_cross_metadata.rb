class CreateCrossMetadata < ActiveRecord::Migration[5.0]
  def change
    create_table :cross_metadata do |t|
      t.integer :width, null: false
      t.integer :height, null: false
      t.references :question, polymorphic: true, index: true
    end

    create_table :cross_rows do |t|
      t.timestamps
      t.string :row, null: false
      t.references :question, polymorphic: true, index: true
    end

    create_table :cross_hints do |t|
      t.string :hint, null: false
      t.integer :row, null: false
      t.integer :column, null: false
      t.boolean :across, null: false
      t.references :question, polymorphic: true, index: true
    end
  end
end
