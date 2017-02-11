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

  private

  def transform_question_type
    params[:quiz][:questions_attributes].try(:each) do |question_params|
      question_params[:type] = Question.type_from_api(question_params[:type])
    end
  end
end
