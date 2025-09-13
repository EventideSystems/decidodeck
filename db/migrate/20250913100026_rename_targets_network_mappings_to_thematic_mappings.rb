class RenameTargetsNetworkMappingsToThematicMappings < ActiveRecord::Migration[8.0]
  def change
    rename_table :targets_network_mappings, :thematic_mappings
  end
end
