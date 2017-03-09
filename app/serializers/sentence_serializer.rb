class SentenceSerializer < ActiveModel::Serializer
  attributes :id, :text, :is_main
end
