# frozen_string_literal: true

class Authorization < ApplicationRecord
  belongs_to :user, optional: true

  validates :provider, :uid, presence: true
end
