# == Schema Information
#
# Table name: accounts
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :users
  has_many :campaigns

  has_one  :mail_setting

  after_create :create_mail_setting

  # Parse CSV file and create new users with tags
  # Returns how many users created and which values not created with details
  def import_users_from_csv(csv_file, _tags)
    imported_user_count = 0
    import_errors = []

    CSV.foreach(csv_file.path) do |row|
      new_user = users.new(name: row[0], email: row[1])

      new_user.tag_list.add(_tags.downcase.split(',')) if _tags.present?
      if new_user.save
        imported_user_count += 1
      else
        import_errors << new_user.errors.details.try(:values).try(:first).try(:first).try(:values)
      end
    end
    { imported_users: imported_user_count, import_errors: import_errors }
  rescue => e
    Rails.logger.info("ERROR WHILE IMPORTING CSV: #{e}")
    { imported_users: 0, import_errors: e }
  end
end
