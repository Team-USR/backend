class QuizzesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :for_groups]

  resource_description do
    formats ['json']
    error 401, "Need to be logged in"
    error 401, "Unauthorized! Can't access resource"
  end

  def index
    render json: Quiz.all, each_serializer: QuizSerializer
  end

  api :GET, "/quizzes/:id", "Shows a quiz and returns details about session"
  param :id, :number, required: true, desc: "ID of quiz"
  error 404, "Quiz not found"
  error 405, "Quiz not released yet"
  error 405, "No attempts left on this quiz"
  description <<-EOS
    Shows a quiz (in student mode) and returns details about a session. If a
    session doesn't exist then a new one will be created if possible (if there are
    attemps left). The
  EOS
  example <<-EOS
    {
     "quiz":{
        "id": 18,
        "title": "My quiz",
        "attempts": 1,
        "release_date": "2017-03-17",
        "questions": [
           {
              "id": 36,
              "question": "Question 1",
              "type": "single_choice",
              "points": 1,
              "answers": [
                 {
                    "id": 60,
                    "answer": "Answer 1"
                 },
                 {
                    "id":61,
                    "answer": "Answer 2"
                 }
              ]
           },
           {
              "id": 37,
              "question": "Question 2",
              "points": 1,
              "match_default": "default",
              "left": [
                 {
                    "id": "vV90HjE",
                    "answer": "left 2"
                 },
                 {
                    "id": "jgmDXvE",
                    "answer": "left 1"
                 }
              ],
              "right": [
                 {
                    "id": "KLDiI40",
                    "answer": "right 1"
                 },
                 {
                    "id": "MGZfc9k",
                    "answer": "right 2"
                 }
              ],
              "type": "match"
           },
           {
              "id": 38,
              "question": "Question 3",
              "type": "multiple_choice",
              "points": 1,
              "answers": [
                 {
                    "id": 62,
                    "answer": "Answer 1"
                 },
                 {
                    "id": 63,
                    "answer": "Answer 2"
                 },
                 {
                    "id": 64,
                    "answer": "Answer 3"
                 }
              ]
           },
           {
              "id": 39,
              "question": "Question 4",
              "type": "mix",
              "points": 1,
              "words": [
                 "main",
                 "sentence",
                 "is",
                 "here"
              ]
           },
           {
              "id": 40,
              "question": "Question 5",
              "type": "cloze",
              "points": 1,
              "sentence": "test {1} before {2} after {3}",
              "hints": [
                "hint1",
                "hint2",
                "hint3"
              ]
           },
           {
             "id": "41",
             "question": "Question 6",
             "type": "cross",
             "points": 1,
             "width": 3,
             "height": 3,
             "rows": [
               "__*",
               "_*_",
               "_*_"
             ],
             "hints": [
               {
                 "across": true
                 "hint": "hint",
                 "row": 0,
                 "column": 1
               }
             ]
           }
        ]
     },
     "quiz_session":{
        "state":"in_progress",
        "metadata": {
           "1": {
              "answer_id" : 1
           },
           "3": {
              "answer_ids": [
                 6,
                 7
              ]
           }
        }
      }
    }
  EOS
  def show
    @quiz = Quiz.find(params.require(:id))
    if @quiz.release_date > Date.today && !@quiz.published
      return render_error(
        status: :method_not_allowed,
        code: "quiz_not_released_yet"
      )
    else
      @quiz_session = QuizSession.find_by(user: current_user, quiz: @quiz, state: "in_progress")
      if @quiz_session.nil?
        if !@quiz.attempts.zero? && QuizSession.where(user_id: current_user.id).where(quiz_id: @quiz).count >= @quiz.attempts
          return render_error(
            status: :method_not_allowed,
            code: "no_attempts_left"
          )
        else
          @quiz_session = QuizSession.create!(user: current_user, quiz: @quiz, state: "in_progress")
        end
      end
      render json: {
        quiz: QuizSerializer.new(@quiz),
        quiz_session: QuizSessionSerializer.new(@quiz_session)
      }
    end
  end

  api :GET, "/quizzes/:mine", "Shows quizzes created by current user"
  description "Format is identicla to /show"
  def mine
    render json: Quiz.where(user: current_user), each_serializer: QuizSerializer
  end

  api :GET, "/quizzes/:id/edit", "Shows the attributes required for editing a quiz"
  param :id, :number, required: true, desc: "ID of quiz"
  error 404, "Quiz not found"
  error 405, "Quiz not released yet"
  error 405, "No attempts left on this quiz"
  description <<-EOS
    You need this request because the show action doesn't include things
    like the correct sentence, the pairs for match questions etc.
    This will return all the details you need - including ids.
  EOS
  def edit
    @quiz = Quiz.find(params.require(:id))
    authorize! :manage, @quiz
    render json: QuizSerializer.new(@quiz, scope: "edit").as_json
  end

  api :POST, "/quizzes", "Creates a quiz (unpublished)"
  description <<-EOS
  Format is:

      {
        "quiz": {
        "title":"My quiz",
        "attempts": 1,
        "release_date": "2017-03-17",
        "questions_attributes": [
          {
            "question": "Question 1",
            "type": "single_choice",
            "points": 1,
            "answers_attributes": [
              {
                "answer": "Answer 1",
                "is_correct": false
              },
              {
                "answer": "Answer 2",
                "is_correct": true
              }
            ]
          },
          {
            "question": "Question 2",
            "type": "match",
            "points": 1,
            "match_default_attributes":
            	{
            		"default_text": "default"
            	},
            "pairs_attributes": [
              {
                "left_choice": "left 1",
                "right_choice": "right 1"
              },
              {
                "left_choice": "left 2",
                "right_choice": "right 2"
              }
            ]
          },
          {
            "question": "Question 3",
            "type": "multiple_choice",
            "points": 1,
            "answers_attributes": [
              {
                "answer": "Answer 1",
                "is_correct": false
              },
              {
                "answer": "Answer 2",
                "is_correct": true
              },
              {
                "answer": "Answer 3",
                "is_correct": true
              },
              {
                "answer": "Answer 4",
                "is_correct": false
              },
              {
                "answer": "Answer 5",
                "is_correct": false
              }
            ]
          },
          {
            "question": "Question 4",
            "type": "mix",
            "points": 1,
            "sentences_attributes": [
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
          },
          {
            "question": "Question 5",
            "type": "cloze",
            "points": 1,
            "cloze_sentence_attributes": {
              "text": "test {1} before {2} after {3}"
            },
            "gaps_attributes": [
              {
                "gap_text": "text 1",
                "hint_attributes":
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
          },
          {
            "question": "Question 6",
            "type": "cross",
            "metadata_attributes": {
              "width": 4,
              "height": 4
            },
            "rows_attributes": [
              {
                "row": "*abc"
              },
              {
                "row": "*h*d"
              },
              {
                "row": "*e*f"
              },
              {
                "row": "***g"
              }
            ],
            "hints_attributes": [
              {
                "hint": "abc",
                "row": 0,
                "column": 1,
                "across": true
              },
              {
                "hint": "h",
                "row": 1,
                "column": 1,
                "across": false
              },
              // etc...
            ]
          }
        ]
      }
  EOS
  def create
    transform_question_type

    @quiz = Quiz.new(quiz_params.merge(user_id: current_user.id))

    if @quiz.save
      render json: @quiz
    else
      render_activemodel_validations(@quiz.errors)
    end
  end

  api :PATCH, "/quizzes/:id/", "Overrides a quiz attributes"
  param :id, :number, required: true, desc: "ID of quiz"
  error 404, "Quiz not found"
  error 405, "Quiz is already published"
  description "Format is identical to create"
  def update
    @quiz = Quiz.find(params[:id])
    authorize! :manage, @quiz
    transform_question_type
    if @quiz.published == true
      head :method_not_allowed
    elsif @quiz.update_attributes(quiz_params)
      render json: @quiz
    else
      render json: @quiz.errors, status: :unprocessable_entity
    end
  end

  api :POST, "/quizzes/:id/submit", "Submits a quiz"
  param :id, :number, required: true, desc: "ID of quiz"
  error 404, "Quiz not found"
  description <<-EOS
  Submit the answers of the quiz

      {
        "questions":
        [
          {
            "id": 36,
            "answer_id": 61
          },
          {
            "id": 37,
            "pairs":
            [
              {
                "left_choice_id": "vV90HjE",
                "right_choice_id": "MGZfc9k"
              },
              {
                "left_choice_id": "jgmDXvE",
                "right_choice_id": "KLDiI40"
              }
            ]
          },
          {
            "id": 38,
            "answer_ids": [
              63,
              64
            ]
          },
          {
            "id": 39,
            "answer": [
              "main",
              "sentence",
              "here",
              "is"
            ]
          },
          {
            "id": 40,
            "answer_gaps":
            [
              "text 1",
              "text 2",
              "text 3"
            ]
          }
        ]
      }
  EOS
  example <<-EOS
  {
    "points": 4,
    "feeedback": [
      {
        "id": 36,
        "correct": true,
        "correct_answer": 61
      },
      {
        "id": 37,
        "correct": true,
        "correct_pairs": [
          {
            "left_choice_id": "vV90HjE",
            "right_choice_id": "MGZfc9k"
          },
          {
            "left_choice_id": "jgmDXvE",
            "right_choice_id": "KLDiI40"
          }
        ]
      },
      {
        "id": 38,
        "correct": true,
        "correct_answers": [
          63,
          64
        ]
      },
      {
        "id": 39,
        "correct": true,
        "correct_sentences": [
          "main sentence here is",
          "sentence main here is",
          "main sentence is here"
        ]
      },
      {
        "id": 40,
        "correct": false,
        "correct_gaps": [
          "text 3",
          "text 2",
          "text 1"
        ]
      }
    ]
  }
  EOS
  error 404, "Session not started yet"
  def submit
    @quiz = Quiz.find(params[:id])
    @quiz_session = QuizSession.find_by!(user: current_user, quiz: @quiz, state: "in_progress")
    @quiz_session.score = 0
    feedback = []
    params[:questions].each do |question_param|
      question = Question.find_by(id: question_param[:id], quiz_id: @quiz.id)
      if question.nil?
        feedback << {
          id: question_param[:id],
          status: "Error; Question not found"
        }
      else
        checked = question.check(question_param)
        if checked[:correct]
          @quiz_session.score += question.points
        end
        feedback << {
          id: question.id,
        }.merge(checked)
      end
    end
    @quiz_session.metadata = params[:questions]
    @quiz_session.state = "submitted"
    @quiz_session.save
    render json: {
      points: @quiz_session.score,
      feedback: feedback
    }
  end

  api :POST, "/quizzes/:id/for_groups", "Adds the quiz in groups"
  param :id, :number, required: true, desc: "ID of quiz"
  param :groups, Array, of: :number, required: true, desc: "IDs of groups"
  error 404, "Quiz not found"
  def for_groups
    @groups = params.require(:groups).map { |id| Group.find(id) }.uniq
    @quiz = Quiz.find(params[:id])
    @quiz.groups = @groups
    @quiz.save!
    head :created
  end

  api :POST, "/quizzes/:id/publish", "Publish the quiz"
  param :id, :number, required: true, desc: "ID of quiz"
  error 404, "Quiz not found"
  def publish
    @quiz = Quiz.find(params[:id])
    authorize! :manage, @quiz
    @quiz.published = true
    @quiz.save!
    head :ok
  end

  api :POST, "/quizzes/:id/save", "Saves the current format"
  description "Format is identical to submit"
  def save
    @quiz = Quiz.find(params[:id])
    @quiz_session = QuizSession.find_or_create_by(user: current_user, quiz: @quiz, state: "in_progress")
    if @quiz_session.metadata.nil?
      @quiz_session.metadata = {}
    end
    params[:questions].each do |question_param|
      question = @quiz.questions.find(question_param[:id])

      if question.nil?
        raise InvalidParameter.new("No question with #{question_param[:id]} for quiz with id #{@quiz.id}")
      end

      if !question.save_format_correct?(question_param)
        raise InvalidParameter.new("Wrong parameters sent for question with id #{question_param[:id]}")
      end

      @quiz_session.metadata[question_param[:id]] = question_param.except(:id)
    end
    @quiz_session.save
    render json: @quiz_session
  end

  api :DELETE, "/quizzes/:id", "Destroys the quiz"
  param :id, :number, required: true, desc: "ID of quiz"
  error 404, "Quiz not found"
  def destroy
    @quiz = Quiz.find(params[:id])
    authorize! :manage, @quiz
    @quiz.destroy!
    head :ok
  end

  api :POST, "/quizzes/:id/start", "Shows the current details of a quiz and past attempts"
  param :id, :number, required: true, desc: "ID of quiz"
  error 404, "Quiz not found"
  example <<-EOS
  {
    "quiz": {
      "id": 7,
      "title": "My quiz",
      "attempts": 5,
      "creator": "test1@gmail.com",
      "creator_name": "test1"
    },
    "sessions": [
      {
        "state": "submitted",
        "created_at": "Created on 03/16/2017 at 04:35PM",
        "last_updated": "Last updated on 03/16/2017 at 04:37PM",
        "score": 0
      },
      {
        "state": "in_progress",
        "created_at": "Created on 03/16/2017 at 04:37PM",
        "last_updated": "Last updated on 03/16/2017 at 04:37PM"
      }
    ]
  }
  EOS
  def start
    @quiz = Quiz.find(params[:id])
    @quiz_sessions = QuizSession.where(quiz_id: @quiz.id, user_id: current_user.id)

    render json: {
      quiz: QuizStartSerializer.new(@quiz),
      sessions: ActiveModel::Serializer::CollectionSerializer.new(@quiz_sessions, serializer: QuizSessionStartSerializer)
    }
  end

  private

  def transform_question_type
    params[:quiz][:questions_attributes].try(:each) do |question_params|
      next if question_params[:type].nil? && question_params[:id].present?
      type = Question.type_from_api(question_params[:type])

      if type.nil?
        raise InvalidParameter.new("#{question_params[:type]} is not a valid question type")
      end

      question_params[:type] = type
    end
  end

  def quiz_params
    params.require(:quiz).permit(
      :title,
      :attempts,
      :release_date,
      questions_attributes: [
        :question,
        :type,
        :id,
        :points,
        answers_attributes: [
          :id,
          :answer,
          :is_correct,
        ],
        match_default_attributes: [
          :default_text
        ],
        pairs_attributes: [
          :id,
          :left_choice,
          :right_choice,
        ],
        sentences_attributes: [
          :id,
          :text,
          :is_main,
        ],
        cloze_sentence_attributes: [
          :text,
        ],
        gaps_attributes: [
          :id,
          :gap_text,
          hint_attributes: [
            :hint_text,
          ]
        ],
        metadata_attributes: [
          :width,
          :height
        ],
        rows_attributes: [
          :row
        ],
        hints_attributes: [
          :row,
          :column,
          :hint,
          :across
        ]
      ]
    )
  end
end
