class Questions::Match < Question
  belongs_to :quiz
  has_many :pairs, inverse_of: :question, as: :question, dependent: :destroy
  accepts_nested_attributes_for :pairs, allow_destroy: true
  has_one :match_default, inverse_of: :question, as: :question, dependent: :destroy
  accepts_nested_attributes_for :match_default, allow_destroy: true

  def check(question_params, negative_marking)
    result = true
    nr_of_correct_answers = 0
    question_params[:pairs].each do |pair_parameter|
      pair = Pair.find_by(
        left_choice_uuid: pair_parameter[:left_choice_id],
        right_choice_uuid: pair_parameter[:right_choice_id],
        question_id: id
      )
      if pair.nil?
        result = false
      else
        nr_of_correct_answers += 1
      end
    end
    pts = 0
    if !nr_of_correct_answers.zero?
      pts = points / pairs.size * nr_of_correct_answers
    elsif negative_marking
      pts = - points
    end
    result = false if question_params[:pairs].count != pairs.count
    {
      correct: result,
      points: pts,
      correct_pairs: ActiveModel::Serializer::CollectionSerializer.new(pairs, each_serializer: PairSerializer)
    }
  end

  def save_format_correct?(save_params)
    save_params[:pairs].is_a?(Array) &&
      save_params[:pairs].all? do |pair_parameter|
        pair_parameter.key?(:left_choice_id) && pair_parameter.key?(:right_choice_id)
      end
  end
end
