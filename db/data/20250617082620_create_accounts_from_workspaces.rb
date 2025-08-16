# frozen_string_literal: true

class CreateAccountsFromWorkspaces < ActiveRecord::Migration[8.0]
  def up
    accounts = []

    Workspace.order(:created_at).all.each do |workspace|
      existing_account = accounts.find do |account|
        account.users.intersect?(workspace.users).present?
      end

      if existing_account
        existing_account.workspaces << workspace
        existing_account.users |= workspace.users
      else
        new_account = Account.new(name: workspace.name)
        new_account.workspaces << workspace
        new_account.users = workspace.users
        accounts << new_account
      end
    end

    accounts.each do |account|
      if Account.exists?(name: account.name)
        account.name = "#{account.name} (#{SecureRandom.hex(4)})"
      end
      account.save!
      account.workspaces.find_by(name: "Default Workspace").destroy
      account.workspaces.each do |workspace|
        workspace.update!(account: account)
      end
    end
  end

  def down
    Workspace.update_all(account_id: nil)
    AccountsUser.destroy_all
    Account.destroy_all
  end
end
