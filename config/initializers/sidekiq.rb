# uniqueness for activejobs
# https://github.com/mhenrixon/sidekiq-unique-jobs#usage-with-activejob
Sidekiq.default_worker_options = {
  'unique' => :until_and_while_executing,
  'unique_args' => proc do |args|
                     [args.first.except('job_id')]
                   end
}

# Sidekiq client config
Sidekiq.configure_client do |config|
  config.redis = if Rails.env.production?
                   {
                     host: ENV['REDIS_HOST_URL'],
                     port: 6379,
                     db: 0,
                     namespace: 'email_marketing_sidekiq',
                     password: ENV['REDIS_PASSWORD']
                   }
                 else
                   {
                     host: '127.0.0.1',
                     port: 6379,
                     db: 0,
                     namespace: 'email_marketing_sidekiq'
                   }
                 end
end

# Sidekiq server config
Sidekiq.configure_server do |config|
  config.redis = if Rails.env.production?
                   {
                     host: ENV['REDIS_HOST_URL'],
                     port: 6379,
                     db: 0,
                     namespace: 'email_marketing_sidekiq',
                     password: ENV['REDIS_PASSWORD']
                   }
                 else
                   {
                     host: '127.0.0.1',
                     port: 6379,
                     db: 0,
                     namespace: 'email_marketing_sidekiq'
                   }
                 end
end

if Rails.env.production?
  directory_name = '/var/log'

  file_name = "#{directory_name}/#{Rails.env}_#{Rails.application.class.parent_name.underscore}.log"

  system "sudo touch #{file_name}"
  system "sudo chmod 777 #{file_name}"

  file_name = File.join(file_name)

  # Sidekiq::Logging.logger = Logger.new(file_name, 250.megabytes)

  # Sidekiq::Logging.logger = Logger.new(file_name, 10, 100.megabytes)

  Sidekiq::Logging.logger = nil
end
