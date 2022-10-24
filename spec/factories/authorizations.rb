FactoryBot.define do
  factory :authorization do
    user
    provider { "MyString" }
    uid { "MyString" }
    confirmation_token { '1234' }
    confirmed { false }
    temporary_email { user.email }
  end
end
