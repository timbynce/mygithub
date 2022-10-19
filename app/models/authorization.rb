class Authorization < ApplicationRecord
  belongs_to :user, optional: true

  validates :provider, :uid, presence: true
end
