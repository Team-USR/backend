class QuestionsController < ApplicationController
  def check_answer
    @question = Question.find(params[:id])
    if @question.check_answer(params[:answer_id])
      render json: { status: true }
    else
      render json: { status: false }
    end
  end
end
