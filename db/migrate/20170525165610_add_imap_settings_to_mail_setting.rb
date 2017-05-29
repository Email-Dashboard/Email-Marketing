class AddImapSettingsToMailSetting < ActiveRecord::Migration[5.0]
  def change
    add_column :mail_settings, :imap_address,  :string
    add_column :mail_settings, :imap_port,     :string
    add_column :mail_settings, :imap_password, :string
    add_column :mail_settings, :imap_username, :string
  end
end
