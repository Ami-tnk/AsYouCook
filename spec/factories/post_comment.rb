FactoryBot.define do
  factory :post_comment do
    user
    cook
    comment { Faker::Lorem.characters(number: 8) }
  end
end
