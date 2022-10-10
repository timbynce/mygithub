module Commented
  extend ActiveSupport::Concern

  included do
    before_action :find_commentable, only: %i[comment]
  end

  def comment
    @commentable.comments.create!(comment_params.merge(user: current_user))
    render_success
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  def render_success
    render json: { rating: @commentable.rating,
                   resource_name: @commentable.class.name.downcase,
                   resource_id: @commentable.id }
  end

  def render_failure
    @commentable.errors[:unprocessable_entity] << 'Error on Like Action'
    render json: { message: @commentable.errors.full_messages }, status: :unprocessable_entity
  end

  
  def find_commentable
    @commentable = model_klass.find(params[:id])
  end
end
