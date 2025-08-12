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
#  unique_owner_per_account                         (account_id) UNIQUE WHERE ((role)::text = 'owner'::text)
#
FactoryBot.define do
  factory :account_member do
  end
end
