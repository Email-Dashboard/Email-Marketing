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

  has_many :campaign_users, dependent: :destroy
  has_many :campaigns, through: :campaign_users
  has_many :user_attributes

  acts_as_taggable # Alias for user tags

  # Check the uniqueness by email and account_id
  validates_uniqueness_of :email, scope: :account_id
  validates :email, :account, presence: true

  def method_missing(name, *args, &block)
    return data[Regexp.last_match(1)] if name.to_s =~ /^(\w*)$/
    return data_setter(Regexp.last_match(1), *args) if name.to_s =~ /^(\w*)=$/
    super
  end

  def data
    user_attributes.each_with_object({}) do |element, result|
      result[element.key] = element.value
    end
  end

  def data_setter(method, val)
    attr = user_attributes.find_or_initialize_by(key: method)
    attr.value = val
    attr.save
  end
end
