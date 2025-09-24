# frozen_string_literal: true

# Base policy class for data model elements (goals, targets, indicators)
class DataModelElementPolicy < ApplicationPolicy
  delegate :show?, to: :parent_policy
  delegate :update?, to: :parent_policy

  def create?
    parent_policy.create? || parent_policy.update?
  end

  def destroy?
    parent_policy.update?
  end

  private

  def parent_policy
    @parent_policy ||= DataModelPolicy.new(user_context, record.data_model)
  end
end
