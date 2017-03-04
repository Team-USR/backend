class QuizzesController < ApplicationController
  before_action :authenticate_user, only: [:create, :mine, :update]

  def index
    render json: Quiz.all, each_serializer: QuizSerializer
  end

  def show
    render json: Quiz.find(params.require(:id)), serializer: QuizSerializer
  end

  def mine
    render json: Quiz.where(user: current_user), each_serializer: QuizSerializer
  end

  def edit
    @quiz = Quiz.find(params.require(:id))
    authorize! :manage, @quiz
    render json: @quiz, serializer: QuizEditSerializer
  end

  def create
    transform_question_type
    @quiz = Quiz.new(quiz_params.merge(user_id: current_user.id))

    if @quiz.save
      render json: @quiz
    else
      render_activemodel_validations(@quiz.errors)
    end
  end

  def update
    @quiz = Quiz.find(params[:id])
    authorize! :manage, @quiz
    transform_question_type
    if @quiz.update_attributes(quiz_params)
      render json: @quiz
    else
      render json: @quiz.errors, status: :unprocessable_entity
    end
  end

  def check
    @quiz = Quiz.find(params[:id])
    result = []
    params[:questions].each do |question_param|
      question = Question.find_by(id: question_param[:id], quiz_id: @quiz.id)
      if question.nil?
        result << {
          id: question_param[:id],
          status: "Error; Question not found"
        }
      else
        result << {
          id: question.id,
        }.merge(question.check(question_param))
      end
    end
    render json: result
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
      questions_attributes: [
        :question,
        :type,
        :id,
        answers_attributes: [
          :id,
          :answer,
          :is_correct,

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
        ]
      ]
    )
  end
end
