# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::BaseController
      load_and_authorize_resource

      def show
        respond_with @answer, serializer: AnswerShowSerializer
      end

      def create
        @answer = current_resource_owner.answers.create(answer_params.merge(question_id: params[:question_id]))
        
        if @answer.save
          render json: @answer, serializer: AnswerShowSerializer, status: :created
        else
          render json: { errors: @answer.errors }, status: :unprocessable_entity
        end

      end

      def update
        @answer.update(answer_params)

        respond_with @answer, serializer: AnswerShowSerializer
      end

      def destroy
        @answer.destroy
        
        render json: { messages: ['Answer deleted'] }
      end

      private

      def answer_params
        params.require(:answer).permit(:body)
      end
    end
  end
end
