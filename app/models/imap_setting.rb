# == Schema Information
#
# Table name: imap_settings
#
#  id         :integer          not null, primary key
#  account_id :integer
#  address    :string
#  port       :string
#  email      :string
#  password   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ImapSetting < ApplicationRecord
  belongs_to :account
end
