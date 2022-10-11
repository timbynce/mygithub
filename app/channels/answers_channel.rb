# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "answer_question_#{params[:question_id]}"
  end
end
