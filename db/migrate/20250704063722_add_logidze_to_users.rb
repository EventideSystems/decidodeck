class AddLogidzeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :log_data, :jsonb

    reversible do |dir|
      dir.up do
        create_trigger :logidze_on_users, on: :users
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER IF EXISTS "logidze_on_users" on "users";
        SQL
      end
    end
  end
end
