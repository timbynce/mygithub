module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: %i[like dislike cancel]
    before_action :find_user_vote, only: %i[like dislike]
  end

  def like
    if @user_vote.nil?
      Vote.create!(user: current_user, votable: @votable )
      render json: { rating: @votable.likes,
                     resource_name: @votable.class.name.downcase,
                     resource_id: @votable.id }
    end
  end

  def dislike
      @user_vote.destroy
      render json: { rating: @votable.likes,
                     resource_name: @votable.class.name.downcase,
                     resource_id: @votable.id }
  end

  def user_choice
    current_user.votes
  end

  private

  def find_user_vote
    @user_vote = @votable.votes.find_by(user: current_user)
  end

  # @votable.answers.collect(&:votes).find_by(user: current_user)
  # question.answers.collect(&:votes).find_by(user: current_user)
  # question.votes.find_by(user: current_user)
  # Vote.find_by(user: current_user, votable_type: question)

  def find_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

end
