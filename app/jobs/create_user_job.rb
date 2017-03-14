class CreateUserJob < ApplicationJob
  queue_as :user_create_or_update

  rescue_from do
    retry_job queue: :user_create_or_update
  end

  def perform(account_id, row, tags)

    account = Account.find account_id

    account_user = account.users.find_or_initialize_by(email: row['email'])

    account_user.name = row['name']

    account_user.tag_list.add(tags.downcase.split(',')) if tags.present?

    account_user.save!

    # Save key val attributes
    (row.keys - %w(email name)).each { |header| account_user.send("#{header}=", row[header]) }
  end
end
