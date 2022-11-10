# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    question
    author factory: :user
    body { 'MyTextAnswer' }

    trait :invalid do
      body { nil }
    end

    trait :with_attachments do
      after :create do |answer|
        answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"),
                            filename: 'rails_helper.rb')
      end
    end
  end
end
