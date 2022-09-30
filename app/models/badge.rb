class Badge < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question
  
  validates :name, presence: true

  has_one_attached :image
end
