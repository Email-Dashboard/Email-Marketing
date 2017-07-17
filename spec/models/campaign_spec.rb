# == Schema Information
#
# Table name: campaigns
#
#  id                :integer          not null, primary key
#  account_id        :integer
#  name              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  email_template_id :integer
#

require 'rails_helper'

RSpec.describe Campaign, type: :model do
  it { should validate_presence_of(:account) }

  let!(:account_a) { FactoryGirl.create(:account) }
  let!(:account_b) { FactoryGirl.create(:account) }

  let!(:user_a) { FactoryGirl.create(:user, account: account_a) }
  let!(:user_b) { FactoryGirl.create(:user, account: account_b) }

  let!(:template) { FactoryGirl.create(:email_template, account: account_b) }

  let!(:campaign_a) { FactoryGirl.create(:campaign, account: account_a,
                                          email_template: template) }
  let!(:campaign_b) { FactoryGirl.create(:campaign, account: account_b,
                                          email_template: template) }

  context 'Check Campaigns Users' do
    it 'should valid campaign users' do
      campaign_a.users << user_a
      expect(campaign_a.users).to include(user_a)
    end

    it 'should invalid campaign users' do
      expect { campaign_a.users << user_b }.to raise_error(ActiveRecord::RecordInvalid)
      expect(campaign_a.users).to_not include(user_b)
    end
  end

  context 'Check Campaigns Tag' do
    it 'shoul valid taggings' do
      campaign_a.tag_list.add('test')
      campaign_a.save
      campaign_a.reload
      expect(campaign_a.tag_list).to include('test')
    end

    it 'shoul invalid taggings to wrong campaigns' do
      campaign_a.tag_list.add('test')
      campaign_a.save
      campaign_a.reload
      expect(campaign_b.tag_list).to_not include('test')
    end
  end
end
