class AddDefaultLocaleToAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :accounts, :default_locale, :string, default: 'en', null: false
  end
end
