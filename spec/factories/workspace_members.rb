# frozen_string_literal: true

# == Schema Information
#
# Table name: workspace_members
#
#  id           :integer          not null, primary key
#  role         :string           default("member")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#  workspace_id :integer
#
# Indexes
#
#  index_workspace_members_on_user_id                   (user_id)
#  index_workspace_members_on_workspace_id              (workspace_id)
#  index_workspace_members_on_workspace_id_and_user_id  (workspace_id,user_id) UNIQUE
#
FactoryBot.define do
  factory :workspace_member do
    # workspace
    # user
    workspace_role { :member }
  end
end
