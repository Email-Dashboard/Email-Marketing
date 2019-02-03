class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.string :identifier, null: false

      t.timestamps
    end
    add_index :roles, :identifier, unique: true
  end
end