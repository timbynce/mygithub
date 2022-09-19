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
    return unless current_user.is_author?(@answer)

    @question = @answer.question
    @answer.update(answer_params)
  end

  def destroy
    return unless current_user.is_author?(@answer)

    @question = @answer.question
    @answer.destroy
  end

  def update_best
    return unless current_user.is_author?(@answer.question)

    @question = @answer.question
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
end
