class QuizzesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :for_groups]

  def index
    render json: Quiz.all, each_serializer: QuizSerializer
  end

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

  def mine
    render json: Quiz.where(user: current_user), each_serializer: QuizSerializer
  end

  def edit
    @quiz = Quiz.find(params.require(:id))
    authorize! :manage, @quiz
    render json: QuizSerializer.new(@quiz, scope: "edit").as_json
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
        @quiz_session.score += checked[:points]
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

  def for_groups
    @groups = params[:groups].map { |id| Group.find(id) }.uniq
    @quiz = Quiz.find(params[:id])
    @quiz.groups = @groups
    @quiz.save!
    head :created
  end

  def publish
    @quiz = Quiz.find(params[:id])
    authorize! :manage, @quiz
    @quiz.published = true
    @quiz.save!
    head :ok
  end

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

  def destroy
    @quiz = Quiz.find(params[:id])
    authorize! :manage, @quiz
    @quiz.destroy!
    head :ok
  end

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
      :negative_marking,
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
