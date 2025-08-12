class RenameAccountsUsersToAccountMembers < ActiveRecord::Migration[8.0]
  def change
    rename_table :accounts_users, :account_members
  end
end
