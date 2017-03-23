RSpec.shared_context :quizzes_params do
  let(:single_choice_params) do
    {
      question: "Single Choice Question",
      type: "single_choice",
      points: 1,
      answers_attributes: [
        {
          answer: "Answer 1",
          is_correct: false
        },
        {
          answer: "Answer 2",
          is_correct: true
        }
      ]
    }
  end

  let(:multiple_choice_params) do
    {
      question: "Multiple Choice Question",
      type: "multiple_choice",
      points: 1,
      answers_attributes: [
        {
          answer: "Answer 1",
          is_correct: false
        },
        {
          answer: "Answer 2",
          is_correct: true
        },
        {
          answer: "Answer 3",
          is_correct: true
        },
        {
          answer: "Answer 4",
          is_correct: false
        }
      ]
    }
  end

  let(:match_params) do
    {
      question: "Match Question",
      type: "match",
      points: 1,
      match_default_attributes:
        {
          default_text: "default"
        },
      pairs_attributes: [
        {
          left_choice: "left 1",
          right_choice: "right 1"
        },
        {
          left_choice: "left 2",
          right_choice: "right 2"
        }
      ]
    }
  end

  let(:mix_params) do
    {
      question: "Question 4",
      type: "mix",
      points: 1,
      sentences_attributes: [
        {
          "text": "main sentence is here",
          "is_main": true
        },
        {
          "text": "sentence main here is",
          "is_main": false
        },
        {
          "text": "main sentence here is",
          "is_main": false
        }
      ]
    }
  end

  let(:cloze_params) do
    {
      question: "Question 5",
      type: "cloze",
      points: 1,
      cloze_sentence_attributes: {
        "text": "test {1} before {2} after {3}"
      },
      gaps_attributes: [
        {
          "gap_text": "text 1",
          hint_attributes:
            {
              "hint_text": "hint 1"
            }
        },
        {
          "gap_text": "text 2"
        },
        {
          "gap_text": "text 3"
        }
      ]
    }
  end

  let(:cross_params) do
    {
      question: "Question 5",
      type: "cross",
      metadata_attributes: {
        width: 4,
        height: 4
      },
      rows_attributes: [
        {
          row: "*abc"
        },
        {
          row: "*h*d"
        },
        {
          row: "*e*f"
        },
        {
          row: "***g"
        }
      ],
      hints_attributes: [
        {
          hint: "abc",
          row: 0,
          column: 1,
          across: true
        },
        {
          hint: "h",
          row: 1,
          column: 1,
          across: true
        },
        {
          hint: "d",
          row: 1,
          column: 3,
          across: true
        },
        {
          hint: "e",
          row: 2,
          column: 1,
          across: false
        }
        # etc...
      ]
    }
  end
end
