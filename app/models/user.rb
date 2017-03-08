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

  has_many :campaign_users
  has_many :campaigns, through: :campaign_users
  has_many :user_attributes

  acts_as_taggable # Alias for user tags

  # Check the uniqueness by email and account_id
  validates_uniqueness_of :email, scope: :account_id
  validates :email, :account, presence: true

  def method_missing(name, *args, &block)
    return data[$1] if name.to_s =~ /^(\w*)$/
    return data_setter($1, *args)  if name.to_s =~ /^(\w*)=$/
    super
  end

  def data
    user_attributes.inject({}) do |result, element|
      result[element.key] = element.value
      result
    end
  end

  def data_setter(method, val)
    attr = self.user_attributes.find_or_initialize_by(key: method)
    attr.value = val
    attr.save
  end
end
