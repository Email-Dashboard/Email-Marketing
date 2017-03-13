class ChnageColumnStatusToString < ActiveRecord::Migration[5.0]
  def change
    change_column :campaign_users, :status, :string, default: 'draft'
  end
end
