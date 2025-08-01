class EnableHstoreAndCitext < ActiveRecord::Migration[8.0]
  def change
    enable_extension :hstore
    enable_extension :citext
  end
end
