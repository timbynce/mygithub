FactoryBot.define do
  factory :answer do
    question
    author factory: :user
    body { "MyTextAnswer" }

    trait :invalid do
      body { nil }
    end
  end
end
