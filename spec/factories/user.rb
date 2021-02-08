FactoryBot.define do
  factory :user do
    nickname { Faker::Name.name }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
    introduction { Faker::Lorem.characters(number: 30) }
    profile_image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }

    # create_listを用いて、関連する複数のcookを生成る(ここでは5つの投稿を生成)
    after(:create) do |user|
      create_list(:cook, 5, user: user)
    end
  end
end
