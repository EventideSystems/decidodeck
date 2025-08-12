class CreateJoinTableAccountUser < ActiveRecord::Migration[8.0]
  def change
    create_join_table :accounts, :users do |t|
      t.primary_key :id
      t.string :role, null: false, default: 'member'
      t.datetime :deleted_at
      t.timestamps

      t.index [:account_id, :user_id]
      t.index [:user_id, :account_id]
      t.index :account_id, unique: true, where: "role = 'owner'", name: "unique_owner_per_account"
    end
  end
end
