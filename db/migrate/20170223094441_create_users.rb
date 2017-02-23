class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.references :account
      t.string :email
      t.string :name

      t.timestamps
    end
  end
end
