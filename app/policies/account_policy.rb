# frozen_string_literal: true

# Accounts policy
class AccountPolicy < ApplicationPolicy
  # Limit the scope to accounts the current user is a member of or all accounts if the
  # current user is a system admin
  class Scope < ApplicationPolicy::Scope
    def resolve
      if system_admin?
        scope.all
      else
        scope.where(id: current_user_account_ids, expires_on: [nil, Time.zone.now..])
      end
    end

    private

    def current_user_account_ids
      (current_user.owned_accounts.ids + current_user.accounts.ids).uniq
    end
  end

  def index?
    true
  end

  def create? = system_admin?
  def show? = system_admin? || account_member?
  def update? = system_admin? || account_owner?

  def update_protected_attributes? = system_admin?

  def list_members?
    system_admin? || account_admin? || account_owner?
  end

  private

  def account_owner?
    record.owner == current_user
  end

  def account_member?
    record.account_members.where(user: current_user).exists?
  end

  def account_admin?
    record.account_members.where(user: current_user, role: 'admin').exists?
  end
end
