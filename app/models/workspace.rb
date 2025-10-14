# frozen_string_literal: true

# == Schema Information
#
# Table name: workspaces
#
#  id                                                            :integer          not null, primary key
#  classic_grid_mode                                             :boolean          default(FALSE)
#  community_labels                                              :boolean          default(FALSE)
#  deactivated                                                   :boolean
#  deleted_at                                                    :datetime
#  deprecated_allow_sustainable_development_goal_alignment_cards :boolean          default(FALSE)
#  deprecated_allow_transition_cards                             :boolean          default(TRUE)
#  deprecated_expires_on                                         :date
#  deprecated_expiry_warning_sent_on                             :date
#  deprecated_solution_ecosystem_maps                            :boolean
#  deprecated_weblink                                            :string
#  deprecated_welcome_message                                    :text
#  description                                                   :string
#  log_data                                                      :jsonb
#  max_scorecards                                                :integer          default(1)
#  max_users                                                     :integer          default(1)
#  name                                                          :string
#  problem_opportunity_labels                                    :boolean          default(FALSE)
#  sdgs_alignment_card_characteristic_model_name                 :string           default("Targets")
#  sdgs_alignment_card_focus_area_group_model_name               :string           default("Focus Area Group")
#  sdgs_alignment_card_focus_area_model_name                     :string           default("Focus Area")
#  sdgs_alignment_card_model_name                                :string           default("SDGs Alignment Card")
#  transition_card_characteristic_model_name                     :string           default("Characteristic")
#  transition_card_focus_area_group_model_name                   :string           default("Focus Area Group")
#  transition_card_focus_area_model_name                         :string           default("Focus Area")
#  transition_card_model_name                                    :string           default("Transition Card")
#  created_at                                                    :datetime         not null
#  updated_at                                                    :datetime         not null
#  account_id                                                    :bigint
#
# Indexes
#
#  index_workspaces_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class Workspace < ApplicationRecord
  include Searchable

  has_logidze
  include Discardable

  EXPIRY_WARNING_PERIOD = 30.days

  belongs_to :account, optional: true

  # Direct associations
  has_many :workspace_members, dependent: :destroy
  has_many :members, through: :workspace_members, source: :user
  has_many :communities, dependent: :destroy
  has_many :data_models, dependent: :destroy
  has_many :organisations, dependent: :destroy
  has_many :scorecards, dependent: :destroy
  has_many :stakeholder_types, dependent: :destroy
  has_many :subsystem_tags, dependent: :destroy
  has_many :users, through: :workspace_members
  has_many :wicked_problems, dependent: :destroy

  # Through associations
  has_many :initiatives, through: :scorecards

  delegate :owner, to: :account
  alias artifacts scorecards

  validates :name, presence: true

  scope :active,
        lambda {
          joins(:account)
            .where(account: { expires_on: nil }).or(::Workspace.where(account: { expires_on: Time.zone.today.. }))
            .order(created_at: :asc)
        }

  scope :expiring_soon,
        lambda {
          joins(:account)
            .where(account: { expires_on: Time.zone.today..(Time.zone.today + EXPIRY_WARNING_PERIOD) })
            .order(created_at: :asc)
        }

  delegate :expired?, :expires_on, :max_users_reached?, to: :account, allow_nil: true

  def data_models_in_use
    scorecards.map(&:data_model).uniq
  end
end
