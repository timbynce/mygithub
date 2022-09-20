# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :author, class_name: 'User'

  validates :body, presence: true

  def mark_as_best
    question.best_answer.best_flag = false if question.best_answer.present?

    question.best_answer_id = id
    question.best_answer.best_flag = true
  end
end
