class Api::V1::QuestionsController < Api::V1::BaseController
  protect_from_forgery with: :null_session, prepend: true
  
  before_action :find_question, only: %i[show destroy update]
  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question, serializer: QuestionSerializer
  end

  def create
    @question = current_resource_owner.questions.create(question_params)
    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question, status: :accepted
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    render json: { messages: ['Question deleted'] }
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

   def find_question
    @question = Question.find(params[:id])
  end
end
