# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  
  has_one :badge, dependent: :destroy

  has_many_attached :files, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation

  def common_answers
    answers.where.not(id: best_answer_id)
  end

  private


  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
