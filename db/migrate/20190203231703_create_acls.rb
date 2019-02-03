class CreateAcls < ActiveRecord::Migration[5.2]
  def change
    create_table :acls do |t|
      t.references :role, foreign_key: true
      t.references :organization, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
