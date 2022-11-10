class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title

  belongs_to :author

  has_many :answers
  has_many :comments
  has_many :links
  has_many :files

  def short_title
    object.title.truncate(7)
  end

  def comments
    object.comments.map(&:body)
  end

  def links
    object.links.map(&:url)
  end
end
