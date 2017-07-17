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

require 'rails_helper'

RSpec.describe EmailTemplate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
