class RenameWorkspaceUsersToWorkspaceMembers < ActiveRecord::Migration[8.0]
  def change
    rename_table :workspaces_users, :workspace_members
  end
end
