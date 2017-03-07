class AddSentAtToCampaignUser < ActiveRecord::Migration[5.0]
  def change
    add_column :campaign_users, :sent_at, :datetime
  end
end
