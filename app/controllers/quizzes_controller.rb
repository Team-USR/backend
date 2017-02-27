class QuizzesController < ApplicationController
  before_action :authenticate_user, only: :create

  def index
    render json: Quiz.all
  end

  def show
    render json: Quiz.find(params.require(:id))
  end

  def create
    transform_question_type
    @quiz = Quiz.new(quiz_create_params.merge(user_id: current_user.id))

    if @quiz.save
      render json: @quiz
    else
      render_activemodel_validations(@quiz.errors)
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
      type = Question.type_from_api(question_params[:type])

      if type.nil?
        raise InvalidParameter.new("#{question_params[:type]} is not a valid question type")
      end

      question_params[:type] = type
    end
  end

  def quiz_create_params
    params.require(:quiz).permit(
      :title,
      questions_attributes: [
        :question,
        :type,
        answers_attributes: [
          :answer,
          :is_correct
        ],
        pairs_attributes: [
          :left_choice,
          :right_choice
        ],
        sentences_attributes: [
          :text,
          :is_main
        ],
        cloze_sentence_attributes: [
          :text
        ],
        gaps_attributes: [
          :gap_text,
          hint_attributes: [
            :hint_text
          ]
        ]
      ]
    )
  end
end
