# frozen_string_literal: true

class AccountPolicy < ApplicationPolicy # rubocop:disable Style/Documentation
  class Scope < Scope # rubocop:disable Style/Documentation
    def resolve
      if system_admin?
        scope.all
      else
        scope.where(id: AccountsUser.where(user: current_user).pluck(:account_id))
      end
    end
  end

  def index
    system_admin?
  end

  def show?
    system_admin? || account_any_role?(record)
  end

  def create?
    system_admin?
  end

  def update?
    system_admin? || (account_admin?(record) && !record.expired?)
  end

  def update_protected_attributes?
    system_admin?
  end

  def destroy?
    system_admin?
  end

  def switch?
    system_admin? || account_any_role?(record)
  end
end
