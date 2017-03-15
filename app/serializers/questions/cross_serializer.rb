class Questions::CrossSerializer < ActiveModel::Serializer
  attributes :id, :question, :width, :height, :rows, :points, :type
  has_many :hints

  def width
    object.metadata.width
  end

  def height
    object.metadata.height
  end

  def rows
    if scope == "edit"
      object.rows.map(&:row)
    else
      object.rows.map do |row|
        row.row.gsub(/[a-z]/, '_')
      end
    end
  end

  def type
    "cross"
  end
end
