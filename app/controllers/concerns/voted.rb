module Voted
  extend ActiveSupport::Concern

  included do
    LIKE = 1.freeze
    DISLIKE = -1.freeze

    before_action :find_votable, only: %i[like dislike cancel]
    before_action :find_user_vote, only: %i[like dislike]
  end

  def like
    change_rating_by_value(LIKE)
  end

  def dislike
    change_rating_by_value(DISLIKE)
  end

  private

  def find_user_vote
    @user_vote = @votable.votes.find_by(user: current_user)
  end

  def render_success
    render json: { rating: @votable.rating,
                   resource_name: @votable.class.name.downcase,
                   resource_id: @votable.id }
  end

  def render_failure
    @votable.errors[:unprocessable_entity] << "Error on Like Action"
    render json: { message: @votable.errors.full_messages }, status: :unprocessable_entity
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def change_rating_by_value(vote_value)
    return render_failure if current_user.is_author?(@votable)

    if @user_vote.nil?
      Vote.create!(user: current_user, votable: @votable, like_value: vote_value )

      render_success
    else
      return render_failure if @user_vote.like_value == vote_value
      @user_vote.destroy 

      render_success
    end
  end
end
