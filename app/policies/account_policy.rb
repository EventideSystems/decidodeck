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
        account_ids = AccountMember.where(user: current_user).includes(:account).pluck(&:account_id)
        scope.where(id: account_ids)
      end
    end
  end

  def index?
    true
  end

  def create? = system_admin?
  def show? = system_admin? || account_member?
  def update? = system_admin? || account_owner?

  def update_protected_attributes? = system_admin?

  private

  def account_owner?
    record.account_members.where(user: current_user, role: 'owner').exists?
  end

  def account_member?
    record.account_members.where(user: current_user)
  end
end
