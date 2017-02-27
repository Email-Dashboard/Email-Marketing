class CreateEmailTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :email_templates do |t|
      t.references :account, foreign_key: true
      t.string :subject
      t.text :body

      t.timestamps
    end
  end
end
