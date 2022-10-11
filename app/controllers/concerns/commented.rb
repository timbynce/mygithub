module Commented
  extend ActiveSupport::Concern

  included do
    before_action :find_commentable, only: %i[comment]
    after_action :publish_comment, only: [:comment]
  end

  def comment
    @comment = @commentable.comments.create!(comment_params.merge(user: current_user))
  end

  private

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "comments_question_#{@comment.question.id}", {
      partial: ApplicationController.render_with_signed_in_user(
        current_user,
        partial: 'comments/comment',
        locals: { comment: @comment}
      ),
      commentable_type: @comment.commentable_type.downcase,
      commentable_id: @commentable.id
    })
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
  
  def find_commentable
    @commentable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
