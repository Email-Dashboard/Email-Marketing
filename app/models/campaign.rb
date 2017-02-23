class Campaign < ApplicationRecord
  belongs_to :account
  acts_as_taggable # Alias for campaign tags
end
