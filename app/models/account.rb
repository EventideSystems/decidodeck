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
class Account < ApplicationRecord
  acts_as_paranoid
  has_logidze

  include Searchable

  string_enum subscription_type: %i[invoiced free_sdg]
  string_enum default_workspace_grid_mode: %i[classic per_status]

  belongs_to :default_workspace, class_name: 'Workspace', optional: true
  belongs_to :owner, class_name: 'User', optional: true

  has_many :workspaces, dependent: :destroy
  has_many :scorecards, through: :workspaces

  has_many :account_members, dependent: :destroy
  has_many :members, through: :account_members, source: :user

  after_create :create_default_workspace

  # validate :default_i18n_scope, inclusion: { in: [nil] + I18n::Backend::ActiveRecord.config.available_scopes },
  #                               allow_nil: true

  # TODO: Fix this to use the reminder days for each account (subtract expiry_final_reminder_days)
  scope :expiring_soon,
        lambda {
          where(expires_on: Time.zone.today..(Time.zone.today + EXPIRY_WARNING_PERIOD)).order(created_at: :asc)
        }

  def display_name
    name.presence || "Account for #{owner.display_name}"
  end

  def expired? = expires_on.present? && expires_on < Time.zone.today

  def expiry_reminder_sent_on
    [expiry_initial_reminder_sent_on, expiry_final_reminder_sent_on].compact_blank.max
  end

  # Returns a string that can be used as the i18n scope for this account
  def i18n_scope
    id.to_s
  end

  def max_users_reached?
    return false if max_users.zero? || max_users.blank?

    (members + [owner]).compact_blank.uniq.count >= max_users
  end

  private

  # TODO: Move account setup to a service object, or subclass accounts and place specific logic there
  def create_default_workspace
    return if default_workspace.present?

    self.default_workspace = workspaces.create!(
      name: 'Default',
      description: 'Default workspace'
    )
    save!
  end
end
