class AddUniqueIndexToCampaignUser < ActiveRecord::Migration[5.0]
  def change
    add_index :campaign_users, [:campaign_id, :user_id], unique: true
  end
end
