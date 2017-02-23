# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  account_id :integer
#  email      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  belongs_to :account
  acts_as_taggable # Alias for user tags

  # Check the uniqueness by email and account_id
  validates_uniqueness_of :email, scope: :account_id
  validates :email, :account, presence: true
end
