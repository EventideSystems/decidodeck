class AddAccountIdToWorkspaces < ActiveRecord::Migration[8.0]
  def change
    add_reference :workspaces, :account, foreign_key: { to_table: :accounts }, null: true, index: true
  end
end
