# frozen_string_literal: true

# Policy for Reports
class ReportPolicy < ApplicationPolicy
  def index? = true
  def initiatives_report? = true
  def initiatives_results? = true
  def stakeholders_report? = true
  def stakeholders_results? = true
  def impact_card_activity? = true
  def subsystem_summary? = true

  def cross_workspace_percent_actual? = user_has_multiple_active_workspaces?
  def cross_workspace_percent_actual_by_focus_area? = user_has_multiple_active_workspaces?
  def cross_workspace_percent_actual_by_focus_area_tabbed? = user_has_multiple_active_workspaces?

  private

  def user_has_multiple_active_workspaces?
    WorkspacePolicy::Scope.new(user_context, Workspace).resolve.count > 1
  end
end
