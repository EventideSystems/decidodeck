class AddConfirmableFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string
    add_index :users, :confirmation_token, unique: true

    reversible do |direction|
      direction.up do
          User.update_all confirmed_at: DateTime.now
      end
    end
  end
end
