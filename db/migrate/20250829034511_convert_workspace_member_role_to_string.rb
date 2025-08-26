class ConvertWorkspaceMemberRoleToString < ActiveRecord::Migration[8.0]
  def change
    rename_column :workspace_members, :workspace_role, :role
    change_column :workspace_members, :role, :string, default: 'member'

    reversible do |dir|
      dir.up do
        execute <<-SQL.squish
          UPDATE workspace_members
          SET role = CASE role
            WHEN '0' THEN 'member'
            WHEN '1' THEN 'admin'
            ELSE 'member'
          END
        SQL
      end

      dir.down do
        execute <<-SQL.squish
          UPDATE workspace_members
          SET role = CASE role
            WHEN 'member' THEN '0'
            WHEN 'admin' THEN '1'
            ELSE '0'
          END
        SQL
      end
    end
  end
end
