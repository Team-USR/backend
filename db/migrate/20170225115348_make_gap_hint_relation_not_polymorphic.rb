class MakeGapHintRelationNotPolymorphic < ActiveRecord::Migration[5.0]
  def change
    remove_column :hints, :gap_type
  end
end
