# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'MyString' }
    body { 'MyText' }
    author_id factory: :user

    trait :invalid do
      title { nil }
    end

    trait :with_attachments do
      after :create do |question|
        question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                            filename: 'rails_helper.rb')
      end
    end
  end
end
