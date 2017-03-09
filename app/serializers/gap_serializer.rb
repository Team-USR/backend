class GapSerializer < ActiveModel::Serializer
  attributes :id, :gap_text
  has_one :hint
end
