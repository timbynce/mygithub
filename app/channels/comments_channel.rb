class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "comments_question_#{params[:question_id]}"
  end
end
