class V2::QuizzesController < V2::ApplicationController
  def index
    @quizzes = Quiz.all
  end

  def show
    @quiz = Quiz.find_by!(id: params[:id])
  end

  def create
    transform_question_type
    @quiz = Quiz.create!(params[:quiz])
    render json: @quiz
  end

  def check
    @quiz = Quiz.find(params[:id])
    @result = []
    params[:questions].each do |key, value|
      question = Question.find_by(id: key, quiz_id: @quiz.id)
      @result << [question.id, question.check(value).merge(value)]
    end

    @result = @result.to_h
  end

  private

  def transform_question_type
    params[:quiz][:questions_attributes].try(:each) do |question_params|
      question_params[:type] = Question.type_from_api(question_params[:type])
    end
  end
end
