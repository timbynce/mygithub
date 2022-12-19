# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user

  belongs_to :votable, polymorphic: true, touch: true

  validates :user, presence: true
end
