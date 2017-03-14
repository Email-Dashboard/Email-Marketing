require 'csv'

class ImportUsersJob < ApplicationJob
  queue_as :high_priority

  rescue_from do
    retry_job queue: :high_priority
  end

  # Parse CSV file and create new users with tags
  # Send To CreateUserJob for creating each user.
  def perform(account_id, csv_file, tags)
    headers = CSV.open(csv_file.path, 'r', &:first)

    CSV.foreach(csv_file.path, headers: true) do |row|
      CreateUserJob.perform_now(account_id, row, tags, headers)
    end

  rescue => e
    Rails.logger.info("ERROR WHILE IMPORTING CSV: #{e}")
  end
end
