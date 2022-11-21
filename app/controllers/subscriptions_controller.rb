# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  load_resource :question
  load_and_authorize_resource :subscription, through: :question, shallow: true

  def create
    @question = Question.find(params[:question_id])
    @subscription = @question.subscriptions.create(user: current_user)
  end

  def destroy
    @subscription = current_user.subscriptions.find(params[:id])
    @subscription.destroy
  end
end
