FactoryGirl.define do
  factory :note do
    account nil
    title { Faker::Lorem.sentence }
    content "<p> #{Faker::Lorem.paragraph(8)} </p>"
  end
end
