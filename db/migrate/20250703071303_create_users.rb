# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      ## Database authenticatable
      t.citext :email, null: false
      t.string :encrypted_password, null: false

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## User status
      t.string :status, null: false, default: 'active' # active, archived, suspended

      ## Additional fields
      t.string :name, null: false, default: ""
      t.string :locale, null: false, default: "en"
      t.string :time_zone, null: false, default: "UTC"
      t.boolean :admin, null: false, default: false

      ## Discardable
      t.datetime :discarded_at, null: true

      t.timestamps null: false
    end

    # Indexes
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :status
    add_index :users, :name
    add_index :users, :discarded_at

    # Check constraints
    add_check_constraint :users, "status IN ('active', 'suspended', 'archived')", name: "users_valid_status"
  end
end
