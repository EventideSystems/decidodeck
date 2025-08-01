# frozen_string_literal: true

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
FactoryBot.define do
  factory :accounts_user do
  end
end
