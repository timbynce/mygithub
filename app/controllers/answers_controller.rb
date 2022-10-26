# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: [:show]
  before_action :find_question, only: %i[new create]
  before_action :load_answer, only: %i[show destroy update update_best]

  after_action :publish, only: [:create]

  authorize_resource :answer, through: :question, shallow: true,
                              only: [:create, :edit, :update, :destroy, :toggle_best]

  def show; end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  def update_best
    MarkBestAnswerService.call(@question, @answer)
  end

  private

  def publish
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "answer_question_#{params[:question_id]}",
      ApplicationController.render_with_signed_in_user(
        current_user,
        partial: 'answers/answer',
        locals: { answer: @answer }
      )
    )
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url]).merge(author: current_user)
  end
end
