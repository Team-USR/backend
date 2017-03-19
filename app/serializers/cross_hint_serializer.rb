class CrossHintSerializer < ActiveModel::Serializer
  attributes :row, :column, :hint, :across
end
