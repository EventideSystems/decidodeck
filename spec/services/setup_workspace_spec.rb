# frozen_string_literal: true

require 'rails_helper'

describe SetupWorkspace do
  subject { described_class.new(workspace, user) }

  let(:account) { create(:account, subscription_type: 'free_sdg') }
  let(:workspace) { create(:workspace, account: account) }
  let(:user) { create(:user) }

  describe '#call' do
    it 'assigns a default data model for free_sdg workspaces' do # rubocop:disable RSpec/MultipleExpectations
      described_class.call(workspace:)
      expect(workspace.data_models.count).to eq(1)
      expect(workspace.data_models.first.name).to eq('Sustainable Development Goals and Targets')
    end

    it 'creates an example impact card for free_sdg workspaces' do # rubocop:disable RSpec/MultipleExpectations
      described_class.call(workspace:)
      expect(workspace.scorecards.count).to eq(1)
      expect(workspace.scorecards.first.name).to eq('Example Impact Card')
    end

    it 'assigns default stakeholder types for free_sdg workspaces' do # rubocop:disable RSpec/MultipleExpectations
      described_class.call(workspace:)
      names = workspace.stakeholder_types.pluck(:name)
      expect(names).to include('Business')
      expect(names).to include('Education')
    end

    it 'assigns default stakeholders for free_sdg workspaces' do # rubocop:disable RSpec/MultipleExpectations
      described_class.call(workspace:)
      expect(workspace.organisations.count).to be_positive
      expect(workspace.organisations.first.name).to eq('Example Stakeholder')
    end
  end
end
