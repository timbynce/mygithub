# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :find_question, only: %i[new create]
  before_action :load_answer, only: %i[show destroy update update_best]

  def show; end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
  end

  def update
    determ_authorize(@answer)

    @answer.update(answer_params)
  end

  def destroy
    determ_authorize(@answer)

    @answer.destroy
  end

  def update_best
    determ_authorize(@answer)

    @answer.mark_as_best
    @question.save
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body).merge(author: current_user)
  end

  def determ_authorize(answer)
    return unless current_user.is_author?(answer.question)

    @question = answer.question
  end
end
