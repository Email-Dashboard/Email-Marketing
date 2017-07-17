# == Schema Information
#
# Table name: user_attributes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  key        :string
#  value      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserAttribute < ApplicationRecord
  belongs_to :user
end
