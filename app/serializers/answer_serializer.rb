class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :body, :question_id, :created_at, :updated_at

  belongs_to :author
  
  has_many :comments
  has_many :files, serializer: FileSerializer
  has_many :links

  def comments
    object.comments.map(&:body)
  end

  def links
    object.links.map(&:url)
  end
end
