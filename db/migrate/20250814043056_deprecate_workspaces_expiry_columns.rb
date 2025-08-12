class DeprecateWorkspacesExpiryColumns < ActiveRecord::Migration[8.0]
  def change
    rename_column :workspaces, :expires_on, :deprecated_expires_on
    rename_column :workspaces, :expiry_warning_sent_on, :deprecated_expiry_warning_sent_on
  end
end
