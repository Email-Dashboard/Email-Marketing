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

  has_many :campaign_users
  has_many :users, through: :campaign_users

  acts_as_taggable # Alias for campaign tags

  validates :name, :account, presence: true
end
