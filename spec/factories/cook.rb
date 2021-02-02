FactoryBot.define do
  factory :cook do
    user
    cooking_name { Faker::Lorem.characters(number: 8) }
    recipe { Faker::Lorem.characters(number: 20) }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg')) }
  end
end
