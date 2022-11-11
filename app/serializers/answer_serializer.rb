class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :question_id, :created_at, :updated_at
  
  belongs_to :author
end
