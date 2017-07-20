class AddAuthenticationTokenToAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :authentication_token, :string
    add_index  :accounts, :authentication_token, unique: true
  end
end
