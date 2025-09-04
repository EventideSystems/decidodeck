# frozen_string_literal: true

# == Schema Information
#
# Table name: workspaces
#
#  id                                                            :integer          not null, primary key
#  classic_grid_mode                                             :boolean          default(FALSE)
#  community_labels                                              :boolean          default(FALSE)
#  deactivated                                                   :boolean
#  deleted_at                                                    :datetime
#  deprecated_allow_sustainable_development_goal_alignment_cards :boolean          default(FALSE)
#  deprecated_allow_transition_cards                             :boolean          default(TRUE)
#  deprecated_expires_on                                         :date
#  deprecated_expiry_warning_sent_on                             :date
#  deprecated_solution_ecosystem_maps                            :boolean
#  deprecated_weblink                                            :string
#  deprecated_welcome_message                                    :text
#  description                                                   :string
#  log_data                                                      :jsonb
#  max_scorecards                                                :integer          default(1)
#  max_users                                                     :integer          default(1)
#  name                                                          :string
#  problem_opportunity_labels                                    :boolean          default(FALSE)
#  sdgs_alignment_card_characteristic_model_name                 :string           default("Targets")
#  sdgs_alignment_card_focus_area_group_model_name               :string           default("Focus Area Group")
#  sdgs_alignment_card_focus_area_model_name                     :string           default("Focus Area")
#  sdgs_alignment_card_model_name                                :string           default("SDGs Alignment Card")
#  transition_card_characteristic_model_name                     :string           default("Characteristic")
#  transition_card_focus_area_group_model_name                   :string           default("Focus Area Group")
#  transition_card_focus_area_model_name                         :string           default("Focus Area")
#  transition_card_model_name                                    :string           default("Transition Card")
#  created_at                                                    :datetime         not null
#  updated_at                                                    :datetime         not null
#  account_id                                                    :bigint
#
# Indexes
#
#  index_workspaces_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
require 'rails_helper'

RSpec.describe Workspace, type: :model do
  describe 'create workspace' do # rubocop:disable RSpec/EmptyExampleGroup
    # rubocop:disable RSpec/IndexedLet,RSpec/LetSetup,Naming/VariableNumber
    let!(:stakeholder_type_1) { create(:stakeholder_type, name: 'StakeholderType 1', workspace_id: nil) }
    let!(:stakeholder_type_2) { create(:stakeholder_type, name: 'StakeholderType 2', workspace_id: nil) }
    # rubocop:enable RSpec/IndexedLet,RSpec/LetSetup,Naming/VariableNumber

    # NOTE: No longer applicable, as the workspace setup is in the SetupWorkspace service.
    # We should write specs for that class, moving this test over to that.
    # it 'creates stakeholder_types for the workspace' do
    #   workspace = described_class.create(name: 'Test Workspace')

    #   expect(workspace.stakeholder_types.count).to eq(2)
    #   expect(StakeholderType.count).to eq(4)
    #   expect(workspace.stakeholder_types.first.name).to eq('StakeholderType 1')
    #   expect(workspace.stakeholder_types.first.id).not_to eq(stakeholder_type_1.id)
    # end
  end
end
