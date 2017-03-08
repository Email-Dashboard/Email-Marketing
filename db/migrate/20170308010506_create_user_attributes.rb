class CreateUserAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :user_attributes do |t|
      t.references :user, foreign_key: true
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
