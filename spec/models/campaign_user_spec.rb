# == Schema Information
#
# Table name: campaign_users
#
#  id          :integer          not null, primary key
#  campaign_id :integer
#  user_id     :integer
#  status      :string           default("draft")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  sent_at     :datetime
#

require 'rails_helper'

RSpec.describe CampaignUser, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
end
