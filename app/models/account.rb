# frozen_string_literal: true

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
class Account < ApplicationRecord
  acts_as_paranoid
  has_logidze

  include Searchable

  string_enum subscription_type: %i[invoiced free]
  string_enum default_workspace_grid_mode: %i[classic per_status]

  belongs_to :owner, class_name: 'User', optional: true
  belongs_to :default_workspace, class_name: 'Workspace', optional: true

  has_many :workspaces, dependent: :destroy
  has_many :accounts_users, dependent: :destroy
  has_many :users, through: :accounts_users

  validates :name, presence: true, uniqueness: { scope: :deleted_at } # rubocop:disable Rails/UniqueValidationWithoutIndex

  after_create :create_default_workspace

  # TODO: Fix this to use the reminder days for each account (subtract expiry_final_reminder_days)
  scope :expiring_soon,
        lambda {
          where(expires_on: Time.zone.today..(Time.zone.today + EXPIRY_WARNING_PERIOD)).order(created_at: :asc)
        }

  def expired? = expires_on.present? && expires_on < Time.zone.today

  def expiry_reminder_sent_on
    [expiry_initial_reminder_sent_on, expiry_final_reminder_sent_on].compact_blank.max
  end

  def owner
    accounts_users.find(role: 'owner')
  end

  private

  def create_default_workspace
    return if default_workspace.present?

    self.default_workspace = workspaces.create!(
      name: 'Default Workspace',
      description: "Default workspace for #{name}"
    )
    save!
  end
end
