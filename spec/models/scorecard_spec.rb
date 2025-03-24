# frozen_string_literal: true

# == Schema Information
#
# Table name: scorecards
#
#  id                         :integer          not null, primary key
#  deleted_at                 :datetime
#  description                :string
#  name                       :string
#  share_ecosystem_map        :boolean          default(TRUE)
#  share_thematic_network_map :boolean          default(TRUE)
#  type                       :string           default("TransitionCard")
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  community_id               :integer
#  linked_scorecard_id        :integer
#  shared_link_id             :string
#  wicked_problem_id          :integer
#  workspace_id               :integer
#
# Indexes
#
#  index_scorecards_on_deleted_at    (deleted_at)
#  index_scorecards_on_type          (type)
#  index_scorecards_on_workspace_id  (workspace_id)
#
require 'rails_helper'

RSpec.describe Scorecard, type: :model do
  let(:scorecard) { create(:scorecard, initiatives: create_list(:initiative, 10)) }

  describe '#merge' do
    subject(:merged) { scorecard.merge(other_scorecard) }

    let(:other_scorecard) { create(:scorecard, initiatives: create_list(:initiative, 5)) }

    it { expect(merged.name).to eq(scorecard.name) }

    it { expect(merged.description).to eq(scorecard.description) }
    it { expect(merged.shared_link_id).not_to be_blank }
    it { expect(merged.shared_link_id).to eq(scorecard.shared_link_id) }

    it { expect(merged.wicked_problem).to eq(scorecard.wicked_problem) }
    it { expect(merged.community).to eq(scorecard.community) }

    it { expect(merged.initiatives.count).to eq(scorecard.initiatives.count + other_scorecard.initiatives.count) }
    it { expect(merged.initiatives).not_to eq(scorecard.initiatives + other_scorecard.initiatives) }

    it 'removes all initiatives from merged scorecard' do
      merged
      other_scorecard.reload
      expect(other_scorecard.initiatives.count).to eq(0)
    end
  end
end
