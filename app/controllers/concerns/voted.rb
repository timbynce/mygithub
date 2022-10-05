module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[like dislike cancel]
    before_action :find_user_vote, only: %i[like dislike]
  end

  def like
    return render_failure unless @user_vote.nil?

    Vote.create!(user: current_user, votable: @votable )
    render_success
  end

  def dislike
    return render_failure unless @user_vote.present?

    @user_vote.destroy      
    render_success
  end

  def user_choice
    current_user.votes
  end

  private

  def find_user_vote
    @user_vote = @votable.votes.find_by(user: current_user)
  end

  def render_success
    render json: { rating: @votable.likes,
                   resource_name: @votable.class.name.downcase,
                   resource_id: @votable.id }
  end

  def render_failure
    @votable.errors[:unprocessable_entity] << "Error on Action"
    render json: { message: @votable.errors.full_messages }, status: :unprocessable_entity
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

end
