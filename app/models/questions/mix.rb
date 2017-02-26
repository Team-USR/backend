class Questions::Mix < Question
  belongs_to :quiz

  has_many :sentences, inverse_of: :question, as: :question
  accepts_nested_attributes_for :sentences
  validate :sentences_have_same_words, if: :has_sentences?
  validate :has_one_main_sentence, if: :has_sentences?

  def words
    sentences.first.text.split(" ").shuffle
  end

  def check(question_params)
    if words.sort != question_params[:answer].sort
      {
        correct: false,
        correct_sentences: sentences.map(&:text)
      }
    else
      {
        correct: sentences.find_by(text: question_params[:answer].join(" ")) != nil,
        correct_sentences: sentences.map(&:text)
      }
    end
  end

  private

  def sentences_have_same_words
    first_sentence_words = words.sort
    sentences.each do |sentence|
      if sentence.valid?
        sentence_words = sentence.text.split(" ").sort
        if sentence_words != first_sentence_words
          errors.add(:sentences, "has different words")
        end
      end
    end
  end

  def has_one_main_sentence
    if sentences.map(&:is_main).select { |is_main| is_main == true }.count > 1
      errors.add(:sentences, "have multiple main sentences")
    end

    if sentences.map(&:is_main).select { |is_main| is_main == true }.empty?
      errors.add(:sentences, "doesnt' have a main sentences")
    end
  end

  def has_sentences?
    sentences.any?
  end
end
