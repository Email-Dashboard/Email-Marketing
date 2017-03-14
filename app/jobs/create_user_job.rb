class CreateUserJob < ApplicationJob
  queue_as :high_priority

  rescue_from do
    retry_job queue: :high_priority
  end

  def perform(account_id, row, tags, headers)
    account = Account.find account_id
    # If user email exists update other infos
    account_user = if account.users.exists?(email: row[headers.find_index('email')])
                     account.users.find_by(email: row[headers.find_index('email')])
                   else
                     account.users.new(email: row[headers.find_index('email')])
                   end

    account_user.name = row[headers.find_index('name')]
    account_user.tag_list.add(tags.downcase.split(',')) if tags.present?

    account_user.save

    # Save key val attributes
    (headers - %w(email name)).each { |header| account_user.send("#{header}=", row[headers.find_index(header)]) }
  end
end
