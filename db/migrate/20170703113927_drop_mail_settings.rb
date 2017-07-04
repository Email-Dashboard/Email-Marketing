class DropMailSettings < ActiveRecord::Migration[5.0]
  def change
    drop_table :mail_settings
  end
end
