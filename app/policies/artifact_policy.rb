# frozen_string_literal: true

# Artifacts policy
class ArtifactPolicy < ApplicationPolicy
  # Limit the scope to artifacts in the current accounts
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(workspace: current_workspace)
    end
  end

  def index?
    true
  end

  def create?
    any_artifact_class_policy_allows?(:create?)
  end

  def update?
    any_artifact_class_policy_allows?(:update?)
  end

  private

  # TODO: Create a mechanism to avoid hardcoding artifact classes here, perhaps via
  # a registry or configuration
  def any_artifact_class_policy_allows?(action)
    [Scorecard, Initiative].any? do |artifact_class|
      Pundit.policy(user_context, artifact_class).public_send(action)
    end
  end
end
