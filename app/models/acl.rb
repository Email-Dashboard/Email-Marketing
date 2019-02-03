class Acl < ApplicationRecord
  belongs_to :role
  belongs_to :organization
  belongs_to :user
end
