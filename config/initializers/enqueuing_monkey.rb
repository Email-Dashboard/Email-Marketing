module ActiveJob
  module Enqueuing
    extend ActiveSupport::Concern

    module ClassMethods
      def perform_later(*args)
        if Rails.env.production?
          job_or_instantiate(*args).enqueue
        else
          job_or_instantiate(*args).perform_now
        end
      end
    end
  end
end
