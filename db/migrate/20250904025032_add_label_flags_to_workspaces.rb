class AddLabelFlagsToWorkspaces < ActiveRecord::Migration[8.0]
  def change
    add_column :workspaces, :community_labels, :boolean, default: false
    add_column :workspaces, :problem_opportunity_labels, :boolean, default: false

    reversible do |dir|
      dir.up do
        execute <<-SQL.squish
          update workspaces
          set community_labels = true, problem_opportunity_labels = true
          from accounts
          where accounts.id = workspaces.account_id
          and accounts.subscription_type <> 'free_sdg'
        SQL
      end
    end
  end
end
