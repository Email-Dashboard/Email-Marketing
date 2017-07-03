class SmtpSetting < ApplicationRecord
  belongs_to :account

  scope :default_for_campaigns, -> { where(is_default_for_campaigns: true) }
  scope :default_for_reply,     -> { where(is_default_for_reply: true) }

  def all_present?
    from_email.present? && address.present? && port.present? &&
    domain.present? && username.present? && password.present?
  end

  def self.default_for_campaigns
    where(is_default_for_campaigns: true).first
  end

  def self.default_for_reply
    where(is_default_for_reply: true).first
  end
end
