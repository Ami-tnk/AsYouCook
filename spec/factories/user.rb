FactoryBot.define do
  factory :user do
    nickname { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    introduction { Faker::Lorem.characters(number: 30) }
    profile_image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }

    after(:create) do |user|
      create_list(:cook, 3, user: user)
    end
  end
end
