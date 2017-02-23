# == Schema Information
#
# Table name: accounts
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'

RSpec.describe Account, type: :model do
  it { should validate_presence_of(:email) }

  let!(:account_a) { FactoryGirl.create(:account) }
  let!(:account_b) { FactoryGirl.create(:account) }

  let!(:user_a) { FactoryGirl.create(:user, account: account_a) }
  let!(:user_b) { FactoryGirl.create(:user, account: account_b) }

  context 'Check Account Users' do
    it "should valid account_a customers" do
      expect(account_a.users).to include(user_a)
    end

    it "should invalid account_a user" do
      expect(account_b.users).to_not include(user_a)
    end
  end
end
