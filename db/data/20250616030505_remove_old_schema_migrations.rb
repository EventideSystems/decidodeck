# frozen_string_literal: true

class RemoveOldSchemaMigrations < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL.squish
      delete from schema_migrations
      where version < '20250612084851';
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
