class Questions::Mix < Question
  belongs_to :quiz
  has_many :sentences, inverse_of: :question, as: :question
  accepts_nested_attributes_for :sentences
  validate :sentences_have_same_words

  def words
    sentences.first.text.split(" ").shuffle
  end

  def check(question_params)
    {
      correct: words.sort == question_params[:answer].split(" ").sort,
      correct_sentences: sentences.map(&:text)
    }
  end

  private

  def sentences_have_same_words
    first_sentence_words = words.sort
    sentences.each do |sentence|
      sentence_words = sentence.text.split(" ").sort
      if sentence_words != first_sentence_words
        errors.add(:sentences,"has different words")
      end
    end
  end
end
