FactoryGirl.define do
  factory :campaign do
    account nil
    name { Faker::Name.name }
  end
end
