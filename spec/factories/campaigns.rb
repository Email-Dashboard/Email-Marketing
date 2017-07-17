# == Schema Information
#
# Table name: campaigns
#
#  id                :integer          not null, primary key
#  account_id        :integer
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  email_template_id :integer
#

FactoryGirl.define do
  factory :campaign do
    account nil
    name { Faker::Name.name }
  end
end
