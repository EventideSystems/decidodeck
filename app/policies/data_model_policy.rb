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
      WorkspacePolicy::Scope.new(user_context, Workspace).resolve.ids
    end
  end

  def show?
    system_admin? || record_in_scope?
  end

  def create?
    current_workspace_allows_modifications?
  end

  def update?
    record_allows_modifications? && current_workspace_allows_modifications?
  end

  def destroy?
    record_allows_modifications? && current_workspace_allows_modifications?
  end

  def copy_to_current_workspace?
    current_workspace_allows_modifications? && (record_allows_modifications? || record.public_model?)
  end

  private

  # Restrict access to unexpired workspaces and non-free SDG accounts only
  def current_workspace_allows_modifications?
    system_admin? || (current_workspace_not_expired? && !current_account.free_sdg?)
  end

  def record_allows_modifications?
    system_admin? || (workspace_admin?(record.workspace) && record_in_scope? && !record.public_model?)
  end
end
