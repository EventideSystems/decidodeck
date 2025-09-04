# frozen_string_literal: true

# Policy for Community Labels. NB we are phasing these out, so they are turned off by default.
class CommunityPolicy < LabelPolicy
  def index?
    current_workspace.community_labels
  end
end
