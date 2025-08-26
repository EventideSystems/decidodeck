class AddRemoveUniqueIndexOnAccountsName < ActiveRecord::Migration[8.0]
  def change
    remove_index :accounts, :name, unique: true
    change_column_null :accounts, :name, true
  end
end
