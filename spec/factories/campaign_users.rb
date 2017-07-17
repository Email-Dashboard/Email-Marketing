# == Schema Information
#
# Table name: campaign_users
#
#  id          :integer          not null, primary key
#  campaign_id :integer
#  user_id     :integer
#  status      :string           default("draft")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sent_at     :datetime
#

FactoryGirl.define do
  factory :campaign_user do
    campaign nil
    user nil
    status 'draft'
  end
end
