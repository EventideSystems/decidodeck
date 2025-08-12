# frozen_string_literal: true

# == Schema Information
#
# Table name: workspace_members
#
#  id             :integer          not null, primary key
#  workspace_role :integer          default("member")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :integer
#  workspace_id   :integer
#
# Indexes
#
#  index_workspace_members_on_user_id                   (user_id)
#  index_workspace_members_on_workspace_id              (workspace_id)
#  index_workspace_members_on_workspace_id_and_user_id  (workspace_id,user_id) UNIQUE
#
class WorkspaceMember < ApplicationRecord
  # TODO: Rename workspace role to just 'role', convert to string enum
  enum :workspace_role, member: 0, admin: 1

  belongs_to :user
  belongs_to :workspace

  delegate :name, to: :workspace, prefix: true, allow_nil: true
end
