require 'csv'

class ImportUsersJob < ApplicationJob
  queue_as :high_priority

  rescue_from do
    retry_job queue: :high_priority
  end

  # Parse CSV file and create new users with tags
  # Send To CreateUserJob for creating each user.
  def perform(account_id, csv_file_name, tags)
    tags = tags.split(',')

    path = File.join('public/upload', csv_file_name)

    tag_ids = tags.each_with_object([]) do |element, result|
      result << ActsAsTaggableOn::Tag.find_or_create_by(name: element).id
    end

    CSV.foreach(path, headers: true) do |row|
      CreateUserJob.perform_later(account_id, row.to_hash, tag_ids)
    end
  end
end
