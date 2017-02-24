class CreateMailSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :mail_settings do |t|
      t.references :account, foreign_key: true
      t.string     :from_email
      t.string     :address
      t.string     :port
      t.string     :domain
      t.string     :user_name
      t.string     :password

      t.timestamps
    end
  end
end
