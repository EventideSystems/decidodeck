class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.citext :name, null: false
      t.string :description
      t.references :default_workspace, foreign_key: { to_table: :workspaces }
      t.string :default_workspace_grid_mode, default: 'classic', null: false
      t.integer :max_users, default: 1
      t.integer :max_impact_cards, default: 1
      t.date :expires_on
      t.date :expiry_initial_reminder_sent_on
      t.date :expiry_final_reminder_sent_on
      t.integer :expiry_initial_reminder_days, default: 30
      t.integer :expiry_final_reminder_days, default: 3
      t.string :subscription_type, default: 'invoiced', null: false
      t.datetime :deleted_at
      t.timestamps
      t.index :name, unique: true, where: 'deleted_at IS NULL'
    end
  end
end
