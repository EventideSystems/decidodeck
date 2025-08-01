# frozen_string_literal: true

class MoveExpiryDataFromWorkspacesToAccounts < ActiveRecord::Migration[8.0]
  def up
    Account.find_each do |account|
      nominal_workspace = account.workspaces.order(deprecated_expires_on: :asc).first
      next if nominal_workspace.nil? || nominal_workspace.deprecated_expires_on.nil?
      
      # Update the account's expiry data from the nominal workspace
      account.update(
        expires_on: nominal_workspace.deprecated_expires_on,
        expiry_final_reminder_sent_on: nominal_workspace.deprecated_expiry_warning_sent_on
      )
    end
  end

  def down
    # NO OP
  end
end
