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

  def self.calculate_percent(status_count, total_users_count)
    return 0.0 if status_count.nil?
    '%.2f' % ((status_count.to_f / total_users_count) * 100.0)
  end
end
