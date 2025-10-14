# frozen_string_literal: true

# == Schema Information
#
# Table name: artifacts
#
#  id            :integer
#  artifact_type :text
#  deleted_at    :datetime
#  description   :string
#  name          :string
#  created_at    :datetime
#  updated_at    :datetime
#  workspace_id  :integer
#
class Artifact < ApplicationRecord
  # include Searchable

  belongs_to :workspace

  alias_attribute :display_name, :name

  def model_human_name
    artifact_type ? artifact_type.constantize.model_name.human : 'Artifact'
  end

  class << self
    def ransackable_attributes(_auth_object = nil)
      %w[name description artifact_type] + _ransackers.keys
    end

    def ransackable_associations(_auth_object = nil)
      []
    end
  end
end
