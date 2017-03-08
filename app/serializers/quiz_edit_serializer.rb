class QuizEditSerializer < ActiveModel::Serializer
  attributes :id, :title, :published
  has_many :questions

  class Questions::SingleChoiceSerializer < ActiveModel::Serializer
    attributes :id, :question, :type
    has_many :answers

    def type
      "single_choice"
    end

    class AnswerSerializer < ActiveModel::Serializer
      attributes :id, :answer, :is_correct
    end
  end

  class Questions::MultipleChoiceSerializer < ActiveModel::Serializer
    attributes :id, :question, :type
    has_many :answers

    def type
      "multiple_choice"
    end

    class AnswerSerializer < ActiveModel::Serializer
      attributes :id, :answer, :is_correct
    end
  end

  class Questions::MixSerializer < ActiveModel::Serializer
    attributes :id, :question, :type
    has_many :sentences

    def type
      "mix"
    end

    class SentenceSerializer < ActiveModel::Serializer
      attributes :id, :text, :is_main
    end
  end

  class Questions::MatchSerializer < ActiveModel::Serializer
    attributes :id, :question, :type
    has_many :pairs

    def type
      "match"
    end

    class PairSerializer < ActiveModel::Serializer
      attributes :left_choice, :right_choice, :id
    end
  end

  class Questions::ClozeSerializer < ActiveModel::Serializer
    attributes :id, :question, :type
    has_one :cloze_sentence
    has_many :gaps

    def type
      "cloze"
    end

    class ClozeSentenceSerializer < ActiveModel::Serializer
      attributes :text, :id
    end

    class GapSerializer < ActiveModel::Serializer
      attributes :id, :gap_text
      has_one :hint

      class HintSerializer < ActiveModel::Serializer
        attributes :id, :hint_text
      end
    end
  end
end
