# frozen_string_literal: true

# See https://timriley.info/posts/rodauth-meet-hanami
ROM::SQL.migration do
  change do
    create_table :users do
      primary_key :id
      foreign_key :account_id
      column :name, :text, null: false
      column :created_at, :timestamp, null: false, default: Sequel.lit("(now() at time zone 'utc')")
    end
  end
end
