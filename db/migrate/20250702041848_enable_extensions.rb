class EnableExtensions < ActiveRecord::Migration[8.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
    enable_extension 'citext' unless extension_enabled?('citext')
    enable_extension 'hstore' unless extension_enabled?('hstore')
  end
end
