class AddLogidzeToWorkspaces < ActiveRecord::Migration[8.0]
  def change
    add_column :workspaces, :log_data, :jsonb

    reversible do |dir|
      dir.up do
        create_trigger :logidze_on_workspaces, on: :workspaces
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER IF EXISTS "logidze_on_workspaces" on "workspaces";
        SQL
      end
    end
  end
end
