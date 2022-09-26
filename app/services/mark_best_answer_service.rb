# frozen_string_literal: true

class MarkBestAnswerService < ApplicationService
  attr_reader :question, :answer

  def initialize(question, answer)
    @question = question
    @answer = answer
  end

  def call
    return @question.errors.add(:base, "Foreign answer detected") unless @answer.question == @question

    @question.best_answer.best_flag = false if @question.best_answer.present?
    @question.best_answer_id = @answer.id
    @question.best_answer.best_flag = true

    return @question.errors.present? unless @question.save
  end
end
