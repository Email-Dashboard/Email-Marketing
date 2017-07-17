# == Schema Information
#
# Table name: email_templates
#
#  id         :integer          not null, primary key
#  account_id :integer
#  subject    :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class EmailTemplate < ApplicationRecord
  belongs_to :account
  
  has_many :campaigns
end
