class CreateArtifacts < ActiveRecord::Migration[8.0]
  def change
    create_view :artifacts
  end
end
