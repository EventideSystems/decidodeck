# frozen_string_literal: true

# Joins table for users and accounts, allowing users to have different roles in different accounts.
# == Schema Information
#
# Table name: accounts_users
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
#  index_accounts_users_on_account_id_and_user_id  (account_id,user_id)
#  index_accounts_users_on_user_id_and_account_id  (user_id,account_id)
#  unique_owner_per_account                        (account_id) UNIQUE WHERE ((role)::text = 'owner'::text)
#
class AccountsUser < ApplicationRecord
  string_enum role: %i[member admin owner]

  belongs_to :user
  belongs_to :account

  validate :only_one_owner_per_account

  private

  def only_one_owner_per_account
    return unless role == 'owner' && self.class.where(account_id: account_id,
                                                      role: 'owner').where.not(user: user).exists?

    errors.add(:role, 'There can only be one owner per account')
  end
end
