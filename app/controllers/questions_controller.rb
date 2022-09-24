# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers
    @answer = Answer.new
  end

  def new
    @question = Question.new
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
    return unless current_user.is_author?(@question)

    @question.update(question_params)
  end

  def destroy
    if current_user.is_author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Question was successfully deleted.'
    else
      redirect_to @question, notice: 'Only author can delete it!'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, :author_id, files: [])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
