class CreateImapSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :imap_settings do |t|
      t.references :account, foreign_key: true
      t.string :address
      t.string :port
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
