class AddReplyToMailSetting < ActiveRecord::Migration[5.0]
  def change
    add_column :mail_settings, :reply_to, :string
  end
end
