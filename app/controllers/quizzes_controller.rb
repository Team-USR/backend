class QuizzesController < ApplicationController
  before_action :authenticate_user!, only: [:show, :create, :mine, :update, :edit, :submit]

  def index
    render json: Quiz.all, each_serializer: QuizSerializer
  end

  def show
    @quiz = Quiz.find(params.require(:id))
    @quiz_session = QuizSession.find_or_create_by(user: current_user, quiz: @quiz, state: "in_progress")
    render json: {
      quiz: QuizSerializer.new(@quiz),
      quiz_session: QuizSessionSerializer.new(@quiz_session)
    }
  end

  def mine
    render json: Quiz.where(user: current_user), each_serializer: QuizSerializer
  end

  def edit
    @quiz = Quiz.find(params.require(:id))
    authorize! :manage, @quiz
    if @quiz.published == true
      head :method_not_allowed
    else
      render json: @quiz, serializer: QuizEditSerializer
    end
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
    if @quiz.published == true
      head :method_not_allowed
    elsif @quiz.update_attributes(quiz_params)
      render json: @quiz
    else
      render json: @quiz.errors, status: :unprocessable_entity
    end
  end

  def submit
    @quiz = Quiz.find(params[:id])
    @quiz_session = QuizSession.find_by!(user: current_user, quiz: @quiz, state: "in_progress")
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
    @quiz_session.metadata = params[:questions]
    @quiz_session.state = "submitted"
    @quiz_session.save
    render json: result
  end

  def for_groups
    @groups = params[:groups].map { |id| Group.find(id) }.uniq
    @quiz = Quiz.find(params[:id])
    @quiz.groups = @groups
    @quiz.save!
    head :created
  end

  def publish
    @quiz = Quiz.find(params[:id])
    @quiz.published = true
    @quiz.save!
    head :ok
  end

  def save
    @quiz = Quiz.find(params[:id])
    @user = User.first
    @quiz_session = QuizSession.find_or_create_by(user: @user, quiz: @quiz, state: "in_progress")
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
