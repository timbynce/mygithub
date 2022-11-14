# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      before_action :doorkeeper_authorize!

      respond_to :html, :json


      rescue_from CanCan::AccessDenied do |exception|
        render json: { error: ‘access_denied’ }, status: 403
      end

      private

      def current_resource_owner
        return unless doorkeeper_token

        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      def current_ability
        @ability ||= Ability.new(current_resource_owner)
      end
    end
  end
end
