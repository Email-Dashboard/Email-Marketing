class DeviseCreateAccounts < ActiveRecord::Migration[5.0]
  def up
    create_table :accounts do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.timestamps null: false
    end

    add_index :accounts, :email, unique: true
    # add_index :accounts, :reset_password_token, unique: true
    # add_index :accounts, :confirmation_token,   unique: true

    if ActiveRecord::Base.connection.adapter_name == 'SQLServer'
      execute 'CREATE UNIQUE NONCLUSTERED INDEX index_accounts_on_reset_password_token ON dbo.accounts (reset_password_token) WHERE reset_password_token IS NOT NULL;'
    end
    # add_index :accounts, :unlock_token,         unique: true
  end

  def down
    execute 'DROP INDEX index_accounts_on_reset_password_token ON dbo.users;'
    remove_index :accounts, :email
    drop_table 'accounts'
  end
end
