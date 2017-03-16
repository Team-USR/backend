class CreateMatchDefault < ActiveRecord::Migration[5.0]
  def change
    create_table :match_defaults do |t|
      t.string :default_text, null: false
      t.belongs_to :question, polymorphic: true
    end
  end
end
