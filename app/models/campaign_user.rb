# == Schema Information
#
# Table name: campaign_users
#
#  id          :integer          not null, primary key
#  campaign_id :integer
#  user_id     :integer
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CampaignUser < ApplicationRecord
  belongs_to :campaign
  belongs_to :user

  acts_as_taggable # Alias for CampaignUser tags

  after_initialize :set_default_status

  # enum status: %w(draft processed dropped delivered deferred bounce open click spamreport unsubscribe group_unsubscribe group_resubscribe)
  STATUSES = %w(draft processed dropped delivered deferred bounce open click spamreport unsubscribe group_unsubscribe group_resubscribe).freeze

  # custom validation for account uniqueness
  validate :validate_sources_accounts

  def validate_sources_accounts
    if campaign.account != user.account
      errors.add(:campaign, 'Not in a same account!')
    end
  end

  private

  def set_default_status
    status = 'draft' if status.nil?
  end
end
