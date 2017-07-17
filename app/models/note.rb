# == Schema Information
#
# Table name: notes
#
#  id         :integer          not null, primary key
#  account_id :integer
#  title      :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Note < ApplicationRecord
  belongs_to :account

  validates :title, presence: true
end
