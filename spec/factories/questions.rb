FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    author_id factory: :user

    trait :invalid do
      title { nil }
    end
  end
end
