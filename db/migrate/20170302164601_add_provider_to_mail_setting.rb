class AddProviderToMailSetting < ActiveRecord::Migration[5.0]
  def change
    add_column :mail_settings, :provider, :string
  end
end
