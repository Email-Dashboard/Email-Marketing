class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.references :account, foreign_key: true
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
