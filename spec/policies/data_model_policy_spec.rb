# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataModelPolicy do # rubocop:disable RSpec/MultipleMemoizedHelpers
  subject { described_class }

  let(:system_admin) { create(:system_admin) }
  let(:account) { create(:account) }
  let(:workspace_admin) { create(:user) }
  let(:workspace_member) { create(:user) }
  let(:workspace) { create(:workspace, account:) }
  let!(:data_model) { create(:data_model, workspace: workspace, public_model: false) }
  let!(:public_data_model) { create(:data_model, public_model: true) }

  before do
    workspace.workspace_members.create(user: workspace_admin, role: :admin)
    workspace.workspace_members.create(user: workspace_member, role: :member)

    workspace_admin.workspaces.reload
    workspace_member.workspaces.reload
  end

  describe 'Scope' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    it 'includes all for system admin' do
      user_context = UserContext.new(system_admin, workspace)
      scope = described_class::Scope.new(user_context, DataModel).resolve
      expect(scope).to include(data_model, public_data_model)
    end

    it 'includes workspace and public models for normal user' do
      user_context = UserContext.new(workspace_admin, workspace)
      scope = described_class::Scope.new(user_context, DataModel).resolve
      expect(scope).to include(data_model, public_data_model)
    end
  end

  describe 'permissions' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    context 'when current user is system admin' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      subject { described_class.new(UserContext.new(system_admin, workspace), data_model) }

      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_action(:create) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to permit_action(:destroy) }
      it { is_expected.to permit_action(:copy_to_current_workspace) }
    end

    context 'when current user is workspace admin' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      subject { described_class.new(UserContext.new(workspace_admin, workspace), data_model) }

      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_action(:create) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to permit_action(:destroy) }
      it { is_expected.to permit_action(:copy_to_current_workspace) }
    end

    context 'when current account is a Free SDG account' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      subject { described_class.new(UserContext.new(workspace_admin, free_sdg_workspace), free_sdg_data_model) }

      let(:free_sdg_account) { create(:account, :free_sdg) }
      let(:free_sdg_workspace) { create(:workspace, account: free_sdg_account) }
      let(:free_sdg_data_model) { create(:data_model, workspace: free_sdg_workspace) }

      before do
        free_sdg_workspace.workspace_members.create(user: workspace_admin, role: :admin)
        free_sdg_workspace.workspace_members.reload
      end

      it { is_expected.not_to permit_action(:create) }
      it { is_expected.not_to permit_action(:update) }
      it { is_expected.not_to permit_action(:destroy) }
      it { is_expected.not_to permit_action(:copy_to_current_workspace) }
    end

    context 'when the data model is a public model' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      subject { described_class.new(UserContext.new(workspace_admin, workspace), public_data_model) }

      it { is_expected.not_to permit_action(:update) }
      it { is_expected.not_to permit_action(:destroy) }
    end
  end
end
