class CreateSmtpSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :smtp_settings do |t|
      t.references :account, foreign_key: true
      t.string  :from_email
      t.string  :reply_to
      t.string  :provider
      t.string  :address
      t.string  :port
      t.string  :domain
      t.string  :username
      t.string  :password
      t.boolean :is_default, default: false

      t.timestamps
    end
  end
end
