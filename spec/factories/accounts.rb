FactoryGirl.define do
  factory :account do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
