# frozen_string_literal: true

# Policy for Wicked Problem Labels. NB we are phasing these out, so they are turned off by default.
class WickedProblemPolicy < LabelPolicy
  def index?
    current_workspace.problem_opportunity_labels
  end
end
