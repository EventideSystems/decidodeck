class RemoveUniqueOwnerPerAccoutIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :account_members, :account_id, unique: true, where: "role = 'owner'", name: "unique_owner_per_account"
  end
end
