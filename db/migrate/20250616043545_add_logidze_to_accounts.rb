class AddLogidzeToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :log_data, :jsonb

    reversible do |dir|
      dir.up do
        create_trigger :logidze_on_accounts, on: :accounts
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER IF EXISTS "logidze_on_accounts" on "accounts";
        SQL
      end
    end
  end
end
