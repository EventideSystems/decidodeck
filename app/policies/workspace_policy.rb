# frozen_string_literal: true

# Policy for Workspace
class WorkspacePolicy < ApplicationPolicy
  # Policy for Workspace scopes
  class Scope < Scope
    def resolve
      if system_admin?
        scope.all
      else
        scope.where(workspaces: { id: current_user_available_workspace_ids })
      end
    end
  end

  def index
    system_admin?
  end

  def show?
    system_admin? || workspace_any_role?(record)
  end

  def create?
    system_admin?
  end

  def update?
    system_admin? || (workspace_admin?(record) && !record.expired?)
  end

  def update_protected_attributes?
    system_admin?
  end

  def destroy?
    system_admin?
  end

  def switch?
    system_admin? || workspace_any_role?(record)
  end
end
