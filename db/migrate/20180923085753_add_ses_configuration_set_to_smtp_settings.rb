class AddSesConfigurationSetToSmtpSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :smtp_settings, :ses_configuration_set, :string
  end
end
