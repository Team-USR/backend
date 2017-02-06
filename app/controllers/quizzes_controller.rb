class QuizzesController < ApplicationController
  def index
    render json: Quiz.all
  end

  def show
    render json: Quiz.find(params[:id])
  end

  def create
    @quiz = Quiz.create!(params[:quiz])
    render json: @quiz
  end
end
