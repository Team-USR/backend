class V2::QuizzesController < V2::ApplicationController
  def index
    @quizzes = Quiz.all
  end

  def show
    @quiz = Quiz.find_by!(id: params[:id])
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.create!(quiz_params)
    redirect_to v2_quiz(@quiz)
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

  def quiz_params
    params.require(:quiz).permit(
      :title,
      questions_attributes: [
        :question,
        :type,
        answers_attributes: [
          :answer,
          :is_correct,
        ],
        pairs_attributes: [
          :left_choice,
          :right_choice
        ],
      ]
    )
  end
end
