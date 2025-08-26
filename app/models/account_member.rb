# frozen_string_literal: true

# Joins table for users and accounts, allowing users to have different roles in different accounts.
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
#
class AccountMember < ApplicationRecord
  string_enum role: %i[member admin]

  belongs_to :user
  belongs_to :account
end
