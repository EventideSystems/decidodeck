# == Schema Information
#
# Table name: accounts
#
#  id                              :bigint           not null, primary key
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
#  name                            :citext           not null
#  subscription_type               :string           default("invoiced"), not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  default_workspace_id            :bigint
#  owner_id                        :bigint
#
# Indexes
#
#  index_accounts_on_default_workspace_id  (default_workspace_id)
#  index_accounts_on_name                  (name) UNIQUE WHERE (deleted_at IS NULL)
#  index_accounts_on_owner_id              (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (default_workspace_id => workspaces.id)
#  fk_rails_...  (owner_id => users.id)
#
FactoryBot.define do
  factory :account do
    
  end
end
