# frozen_string_literal: true

class MarkBestAnswerService < ApplicationService
  attr_reader :question, :answer

  def initialize(answer)
    @question = answer.question
    @answer = answer
  end

  def call
    return @question.errors.add(:base, "Foreign answer detected") unless @answer.question == @question

    if @question.best_answer.present?
      @question.best_answer.best_flag = false 
      return @answer.errors.present? unless @question.best_answer.save
    end

    @question.best_answer_id = @answer.id

    @question.badge.user = @answer.author if @question.badge.present?
    @answer.best_flag = true
    return @question.errors.present? unless @question.save
    return @answer.errors.present? unless @answer.save
  end
end
