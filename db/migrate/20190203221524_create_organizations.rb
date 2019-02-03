class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :subdomain, null: false

      t.timestamps
    end

    add_index :organizations, :subdomain, unique: true
  end
end
