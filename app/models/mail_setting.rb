class MailSetting < ApplicationRecord
  belongs_to :account

  def all_present?
    from_email.present? && address.present? && port.present? &&
    domain.present? && address.present? && user_name.present?
  end
end
