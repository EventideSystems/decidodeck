# frozen_string_literal: true

# == Schema Information
#
# Table name: account_members
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  role       :string           default("member"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_account_members_on_account_id_and_user_id  (account_id,user_id)
#  index_account_members_on_user_id_and_account_id  (user_id,account_id)
#  unique_owner_per_account                        (account_id) UNIQUE WHERE ((role)::text = 'owner'::text)
#
require 'rails_helper'

RSpec.describe AccountMember, type: :model do
  let(:account) { create(:account, name: 'Test Account') }
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  context 'when validating owner role' do
    before do
      create(:account_member, account:, user:, role: 'owner')
    end

    it 'allows one owner per account' do # rubocop:disable RSpec/MultipleExpectations
      account_member = build(:account_member, account:, user: other_user, role: 'owner')

      expect(account_member).not_to be_valid
      expect(account_member.errors[:role]).to include('There can only be one owner per account')
    end

    it 'allows other roles in the same account' do
      account_member = build(:account_member, account:, user: other_user, role: 'member')

      expect(account_member).to be_valid
    end

    it 'allows owner roles in different accounts' do
      other_account = create(:account, name: 'Other Account')
      account_member = build(:account_member, account: other_account, user:, role: 'owner')

      expect(account_member).to be_valid
    end
  end
end
