FactoryBot.define do
  factory :badge do
    name { "MyAward" }
    after(:build) do |badge|
      badge.image.attach(
        io: File.open("#{Rails.root}/123.jpg"),
        filename: '123.jpg'
      )
    end
  end
end
