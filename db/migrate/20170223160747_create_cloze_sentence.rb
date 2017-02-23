class CreateClozeSentence < ActiveRecord::Migration[5.0]
  def change
    create_table :cloze_sentences do |t|
      t.string :text, null: false
      t.belongs_to :question, polymorphic: true
    end
  end
end
