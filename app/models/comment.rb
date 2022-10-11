class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  
  validates :user, presence: true

  def question
    return commentable if commentable.is_a?(Question)
    commentable.question
  end
end
