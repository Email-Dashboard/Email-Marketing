class AddEmailTemplateToCampaign < ActiveRecord::Migration[5.0]
  def change
    add_reference :campaigns, :email_template, foreign_key: true
  end
end
