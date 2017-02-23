FactoryGirl.define do
  factory :user do
    account nil
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
