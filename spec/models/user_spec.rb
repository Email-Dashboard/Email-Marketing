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

  let!(:user_a) { FactoryGirl.create(:user, account: account_a) }
  let!(:user_b) { FactoryGirl.create(:user, account: account_b) }

  let!(:template) { FactoryGirl.create(:email_template, account: account_b) }

  let!(:campaign_a) { FactoryGirl.create(:campaign, account: account_a,
                                          email_template: template) }
  let!(:campaign_b) { FactoryGirl.create(:campaign, account: account_b,
                                          email_template: template) }

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

  context 'Check Users Campaigns' do
    it 'should valid campaign users' do
      user_a.campaigns << campaign_a
      expect(user_a.campaigns).to include(campaign_a)
    end

    it 'should invalid campaign users' do
      expect { user_a.campaigns << campaign_b }.to raise_error(ActiveRecord::RecordInvalid)
      expect(user_a.campaigns).to_not include(campaign_b)
    end
  end

  context 'Check Users Tag' do
    it 'shoul valid taggings' do
      user_a.tag_list.add('test')
      user_a.save
      user_a.reload
      expect(user_a.tag_list).to include('test')
    end

    it 'shoul invalid taggings to wrong users' do
      user_a.tag_list.add('test')
      user_a.save
      user_a.reload
      expect(user_b.tag_list).to_not include('test')
    end
  end
end
