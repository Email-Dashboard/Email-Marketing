FactoryGirl.define do
  factory :email_template do
    account nil
    subject { Faker::Lorem.sentence }
    body "<p> #{Faker::Lorem.paragraph(8)} </p>"
  end
end
