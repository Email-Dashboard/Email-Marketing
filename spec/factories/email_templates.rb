FactoryGirl.define do
  factory :email_template do
    account nil
    subject "MyString"
    body "MyText"
  end
end
