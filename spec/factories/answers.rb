FactoryBot.define do
  factory :answer do
    question
    author factory: :user
    body { "MyText" }

    trait :invalid do
      body { nil }
    end
  end
end
