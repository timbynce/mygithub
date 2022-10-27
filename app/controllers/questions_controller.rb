# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show update destroy]

  after_action :publish, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers
    @answer = Answer.new
    @answer.links.new
    gon.push({ question_id: @question.id })
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_badge
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question was successfully deleted.'
  end

  private

  def publish
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question_partial',
        locals: { question: @question }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, :author_id, files: [], links_attributes: %i[name url],
                                                                badge_attributes: %i[name image])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
