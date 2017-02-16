class QuizzesController < ApplicationController
  def index
    render json: Quiz.all
  end

  def show
    render json: Quiz.find(params[:id])
  end

  def create
    transform_question_type
    @quiz = Quiz.create!(params[:quiz])
    render json: @quiz
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
      question_params[:type] = Question.type_from_api(question_params[:type])
    end
  end
end
