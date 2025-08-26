# frozen_string_literal: true

# Policy for impact card model records
class DataModelPolicy < ApplicationPolicy
  # Scope class for LabelPolicy
  class Scope < Scope
    def resolve
      if system_admin?
        scope.all
      else
        scope.where(workspace_id: workspace_ids).or(DataModel.where(public_model: true))
      end
    end

    def workspace_ids
      WorkspacePolicy::Scope.new(user_context, Workspace).scope.ids
    end

    private

    # Duplicated in WorkspacePolicy
    def current_user_available_workspace_ids
      (
        current_user.workspaces_from_admin_accounts.ids +
        current_user.workspaces_from_owned_accounts.ids +
        current_user.workspaces.ids
      ).uniq
    end
  end

  def index?
    system_admin? # Temporarily restrict to system admins
  end

  def show?
    system_admin? || record_in_scope?
  end

  def create?
    system_admin? || (workspace_admin?(current_workspace) && current_workspace_not_expired?)
  end

  def update?
    system_admin? || (workspace_admin?(current_workspace) && record_in_scope? && current_workspace_not_expired?)
  end

  def destroy?
    system_admin? || (workspace_admin?(current_workspace) && record_in_scope? && current_workspace_not_expired?)
  end

  def copy_to_current_workspace?
    system_admin? || (
      workspace_admin?(current_workspace) &&
      (workspace_admin?(record.workspace) || record.public_model) &&
      current_workspace_not_expired?
    )
  end
end
