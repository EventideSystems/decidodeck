# frozen_string_literal: true

# == Schema Information
#
# Table name: accounts
#
#  id                              :bigint           not null, primary key
#  default_locale                  :string           default("en"), not null
#  default_workspace_grid_mode     :string           default("classic"), not null
#  deleted_at                      :datetime
#  description                     :string
#  expires_on                      :date
#  expiry_final_reminder_days      :integer          default(3)
#  expiry_final_reminder_sent_on   :date
#  expiry_initial_reminder_days    :integer          default(30)
#  expiry_initial_reminder_sent_on :date
#  log_data                        :jsonb
#  max_impact_cards                :integer          default(1)
#  max_users                       :integer          default(1)
#  name                            :citext
#  subscription_type               :string           default("invoiced"), not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  default_workspace_id            :bigint
#  owner_id                        :integer
#
# Indexes
#
#  index_accounts_on_default_workspace_id  (default_workspace_id)
#  index_accounts_on_owner_id              (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (default_workspace_id => workspaces.id)
#
FactoryBot.define do
  factory :account do
    name { FFaker::Company.name }
    description { FFaker::Lorem.sentence }
    max_users { 5 }
    max_impact_cards { 5 }
    subscription_type { 'invoiced' }
  end

  trait :free_sdg do
    max_users { 2 }
    max_impact_cards { 2 }
    subscription_type { 'free_sdg' }
  end
end
