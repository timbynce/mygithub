# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :questions, class_name: 'Question', foreign_key: :author_id
  has_many :answers, class_name: 'Answer', foreign_key: :author_id
  has_many :badges
  has_many :votes, dependent: :destroy
  has_many :authorizations
  has_many :subscriptions, dependent: :destroy

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def self.generate_user(email)
    password = Devise.friendly_token[0, 20]
    User.create!(email: email, password: password, password_confirmation: password)
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def subscribed?(question)
    subscriptions.where(question: question).exists?
  end
end
