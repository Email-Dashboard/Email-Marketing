# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  account_id :integer
#  email      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:account_a) { FactoryGirl.create(:account) }
  let!(:account_b) { FactoryGirl.create(:account) }

  context 'Check multitenancy between accounts' do
    it 'try same email to different accounts' do
      expect(FactoryGirl.create(:user, email: 'test@tester.com', account: account_a)).to be_valid
      expect(FactoryGirl.create(:user, email: 'test@tester.com', account: account_b)).to be_valid
    end

    it 'try same email to same account' do
      expect(FactoryGirl.create(:user, email: 'test1@test.com', account: account_a)).to be_valid
      expect { FactoryGirl.create(:user, email: 'test1@test.com', account: account_a) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
