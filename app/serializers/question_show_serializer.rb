class QuestionShowSerializer < QuestionSerializer
  belongs_to :author

  has_many :answers
  has_many :comments
  has_many :links
  has_many :files, serializer: FileSerializer

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
