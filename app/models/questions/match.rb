class Questions::Match < Question
  belongs_to :quiz
  has_many :pairs, inverse_of: :question, as: :question
  accepts_nested_attributes_for :pairs

  def check(question_params)
    result = true
    question_params[:pairs].each do |pair_parameter|
      pair = Pair.find_by(
        left_choice_uuid: pair_parameter[:left_choice_id],
        right_choice_uuid: pair_parameter[:right_choice_id],
        question_id: id
      )
      result = false if pair.nil?
    end
    result = false if question_params[:pairs].count != pairs.count
    {
      correct: result,
      correct_pairs: ActiveModel::Serializer::CollectionSerializer.new(pairs, each_serializer: PairSerializer)
    }
  end

  def answer_params
    "pairs"
  end
end
