# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(ChecklistItemPolicy) do # rubocop:disable RSpec/MultipleMemoizedHelpers
  let(:policy) { described_class }
  let(:account) { create(:account) }
  let(:system_admin_user) { create(:user, :admin) }
  let(:account_admin_user) { create(:user) }
  let(:account_member_user) { create(:user) }
  let(:scorecard) { create(:scorecard, account:) }
  let(:initiative) { create(:initiative, scorecard:) }

  before do
    account.accounts_users.create(user: account_admin_user, account_role: :admin)
    account.accounts_users.create(user: account_member_user, account_role: :member)
  end

  permissions '.scope' do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :show? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :create? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  %i[show? update?].each do |action|
    permissions(action) do
      it "grants #{action} if user is a system admin" do
        expect(policy).to(permit(UserContext.new(system_admin_user, account), ChecklistItem.new(initiative:)))
      end

      it "grants #{action} if user is an account admin" do
        expect(policy).to(permit(UserContext.new(account_admin_user, account), ChecklistItem.new(initiative:)))
      end

      it "grants #{action} if user is an account member" do
        expect(policy).to(permit(UserContext.new(account_member_user, account), ChecklistItem.new(initiative:)))
      end
    end
  end

  permissions :destroy? do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
