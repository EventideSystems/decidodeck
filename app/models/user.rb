# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  accepted_terms_at      :datetime
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  deleted_at             :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  name                   :string
#  profile_picture        :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  system_role            :integer          default("member")
#  time_zone              :string           default("Adelaide")
#  unconfirmed_email      :string
#  created_at             :datetime
#  updated_at             :datetime
#  invited_by_id          :integer
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE WHERE (deleted_at IS NULL)
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invitations_count     (invitations_count)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_name                  (name)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_system_role           (system_role)
#
class User < ApplicationRecord
  include Searchable

  has_paper_trail
  include Discardable

  enum :system_role, %i[member admin], default: :member # rubocop:disable Rails/EnumHash

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :confirmable, :invitable, :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable

  has_many :account_members, dependent: :destroy
  has_many :accounts, through: :account_members
  has_many :workspace_members, dependent: :destroy
  has_many :workspaces, through: :workspace_members

  has_many :admin_account_members,
           -> { where(role: 'admin') },
           class_name: 'AccountMember',
           inverse_of: :user,
           dependent: :destroy

  has_many :member_account_members,
           -> { where(role: 'member') },
           class_name: 'AccountMember',
           inverse_of: :user,
           dependent: :destroy

  has_many :admin_accounts, through: :admin_account_members, source: :account
  has_many :owned_accounts, class_name: 'Account', foreign_key: :owner_id, dependent: :nullify, inverse_of: :owner
  has_many :member_accounts, through: :member_account_members, source: :account

  has_many :workspaces_from_admin_accounts, through: :admin_accounts, source: :workspaces
  has_many :workspaces_from_owned_accounts, through: :owned_accounts, source: :workspaces

  # SMELL: Not sure we still need this
  accepts_nested_attributes_for :workspace_members, allow_destroy: true

  # Virtual attributes used when inviting or updating users
  attr_accessor :initial_workspace_role, :initial_system_role, :workspace_role
  # Virtual attributes to hold the subscription type and host during user sign-up,
  # used to pass to the mailer for customizing email content and links
  attr_accessor :subscription_type, :host

  def self.ransackable_attributes(_auth_object = nil)
    %w[name email] + _ransackers.keys
  end

  # Used by Devise to determine if the user is active and can sign in.
  def active_for_authentication?
    super && (admin? || default_workspace.present?)
  end

  def available_workspaces
    (workspaces_from_admin_accounts + workspaces_from_owned_accounts + workspaces).uniq
  end

  # TODO: Consider converting this to symbols, or move to a helper method
  def status
    return 'deleted' if deleted_at.present?
    return 'invitation-pending' if invitation_token.present?

    'active'
  end

  # Returns the user's display name, which is their name if present, otherwise their email.
  # TODO: Consider stripping out the email domain and only showing the username.
  # Might also consider moving this to a helper
  def display_name
    name.presence || email.split('@').first.titleize
  end

  def accepted_terms? = accepted_terms_at.present?

  def accept_terms!
    update!(accepted_terms_at: Time.current)
  end

  def admin? = system_role == 'admin'

  def member? = system_role == 'member'

  # Returns the user's default workspace, which is the first workspace they belong to.

  # This really belongs in a controller - or possibly as a 'current_workspace' attribute on
  # the user record that is checked on the controller level.
  def default_workspace
    user_context = UserContext.new(self, nil)
    WorkspacePolicy::Scope.new(user_context, Workspace).resolve.first
  end

  protected

  def send_devise_notification(notification, *args)
    args.second[:subscription_type] = subscription_type
    args.second[:host] = host
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
