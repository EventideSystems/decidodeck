# frozen_string_literal: true

# Set up new workspace with default data
class SetupWorkspace
  attr_reader :workspace, :subscription_type

  def self.call(workspace:)
    new(workspace:).call
  end

  def initialize(workspace:)
    @workspace = workspace
    @subscription_type = workspace.account.subscription_type.to_sym
  end

  def call
    create_stakeholder_types
    create_data_models
    create_stakeholders
    create_impact_cards
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

  def create_data_models # rubocop:disable Metrics/MethodLength
    return if workspace.data_models.exists?

    case subscription_type
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
    return if workspace.stakeholder_types.exists?

    DEFAULT_STAKEHOLDER_TYPES.each do |name, color|
      workspace.stakeholder_types.create!(name: name, color: color, workspace: workspace)
    end
  end

  def create_stakeholders
    return unless subscription_type == :free_sdg

    workspace.organisations.create!(
      name: 'Example Stakeholder',
      description: 'This is an example stakeholder. You can edit or delete it.',
      stakeholder_type: workspace.stakeholder_types.find_by(name: 'Business')
    )
  end

  def create_impact_cards # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    return unless subscription_type == :free_sdg

    workspace.scorecards.create!(
      name: 'Example Impact Card',
      description: 'This is an example impact card. You can edit or delete it.',
      data_model: workspace.data_models.first
    ).tap do |scorecard|
      scorecard.initiatives.create(
        name: 'Example Initiative',
        description: 'This is an example initiative. You can edit or delete it.'
      ).tap do |initiative|
        if workspace.organisations.any?
          initiative.initiatives_organisations.create(organisation: workspace.organisations.first)
        end
      end
    end
  end
end
