# == Schema Information
#
# Table name: campaigns
#
#  id         :integer          not null, primary key
#  account_id :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Campaign < ApplicationRecord
  belongs_to :account
  belongs_to :email_template

  has_many :campaign_users
  has_many :users, through: :campaign_users

  acts_as_taggable # Alias for campaign tags

  validates :name, :email_template, :account, presence: true

  def draft_precent
    (campaign_users.draft.count / campaign_users.count) * 100.0
  end

  def processed_precent
    (campaign_users.processed.count / campaign_users.count) * 100.0
  end

  def dropped_precent
    (campaign_users.dropped.count / campaign_users.count) * 100.0
  end

  def delivered_precent
    (campaign_users.delivered.count / campaign_users.count) * 100.0
  end

  def deferred_precent
    (campaign_users.deferred.count / campaign_users.count) * 100.0
  end

  def bounce_precent
    (campaign_users.bounce.count / campaign_users.count) * 100.0
  end

  def open_precent
    (campaign_users.open.count / campaign_users.count) * 100.0
  end

  def click_precent
    (campaign_users.click.count / campaign_users.count) * 100.0
  end

  def spamreport_precent
    (campaign_users.spamreport.count / campaign_users.count) * 100.0
  end

  def unsubscribe_precent
    (campaign_users.unsubscribe.count / campaign_users.count) * 100.0
  end
end
