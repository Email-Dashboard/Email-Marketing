class EmailTemplate < ApplicationRecord
  belongs_to :account
  
  has_many :campaigns
end
