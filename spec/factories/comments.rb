# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    association :user, factory: :user
    association :commentable, factory: :question
    body { 'Comment one' }
  end
end
