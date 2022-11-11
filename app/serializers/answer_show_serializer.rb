class AnswerShowSerializer < AnswerSerializer
  has_many :comments
  has_many :files, serializer: FileSerializer
  has_many :links

  belongs_to :author

  def comments
    object.comments.map(&:body)
  end

  def links
    object.links.map(&:url)
  end
end
