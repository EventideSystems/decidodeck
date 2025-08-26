# frozen_string_literal: true

# Set up new workspace with default data
class SetupWorkspace
  attr_reader :workspace

  def self.call(workspace:)
    new(workspace:).call
  end

  def initialize(workspace:)
    @workspace = workspace
  end

  def call
    create_stakeholder_types
    create_data_models
  end

  private

  DEFAULT_STAKEHOLDER_TYPES = [
    ['Business', '#FF6D24'],
    ['Education', '#FF5353'],
    ['Federal government', '#1CB85D'],
    ['Formal community group', '#914bb4'],
    ['Individual', '#FD9ACA'],
    ['Informal community group', '#7993F2'],
    ['Local government', '#008C8C'],
    ['Non-government Organisations', '#2E74BA'],
    ['Not for profit', '#009BCC'],
    ['Social Enterprise', '#F7C80B'],
    ['State government', '#00CCAA']
  ].freeze

  def create_data_models
    case workspace.account.subscription_type.to_sym
    when :free_sdg
      DataModels::Import.call(
        filename: Rails.root.join('db/data_models/sustainable_development_goals_and_targets.yml'), workspace: workspace
      )
    else
      Dir.glob(Rails.root.join('db/data_models/*.yml')).each do |yml|
        DataModels::Import.call(filename: yml, workspace: workspace)
      end
    end
  end

  def create_stakeholder_types
    DEFAULT_STAKEHOLDER_TYPES.each do |name, color|
      workspace.stakeholder_types.create!(name: name, color: color, workspace: workspace)
    end
  end
end
