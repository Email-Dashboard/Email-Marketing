class CreateCampaignUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :campaign_users do |t|
      t.references :campaign, foreign_key: true
      t.references :user, foreign_key: true
      t.integer    :status, default: 0

      t.timestamps
    end
  end
end
