# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    association :user, factory: :user
    association :votable, factory: :question

    trait :like do
      like_value { 1 }
    end

    trait :dislike do
      like_value { -1 }
    end
  end
end
