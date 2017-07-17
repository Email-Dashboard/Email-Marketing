# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  account_id :integer
#  title      :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :note do
    account nil
    title { Faker::Lorem.sentence }
    content "<p> #{Faker::Lorem.paragraph(8)} </p>"
  end
end
