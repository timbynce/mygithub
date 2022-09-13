# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :find_question, only: %i[index new create show]
  before_action :load_answer, only: %i[show destroy]

  def show; end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.build(answer_params)
    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.is_author?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Answer was successfully deleted.'
    else
      render 'questions/show', notice: 'Only author can delete it!'
    end
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
