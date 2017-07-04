class SmtpSetting < ApplicationRecord
  belongs_to :account

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
