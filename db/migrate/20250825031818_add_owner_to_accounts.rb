class AddOwnerToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :owner_id, :integer, null: true
    add_index :accounts, :owner_id
  end
end
