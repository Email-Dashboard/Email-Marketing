# == Schema Information
#
# Table name: email_templates
#
#  id         :integer          not null, primary key
#  account_id :integer
#  subject    :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :email_template do
    account nil
    subject { Faker::Lorem.sentence }
    body "<p> #{Faker::Lorem.paragraph(8)} </p>"
  end
end
