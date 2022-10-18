# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  has_many :questions, class_name: 'Question', foreign_key: :author_id
  has_many :answers, class_name: 'Answer', foreign_key: :author_id
  has_many :badges
  has_many :votes, dependent: :destroy
  has_many :authorizations

  def is_author?(resource)
    id == resource.author_id
  end

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
