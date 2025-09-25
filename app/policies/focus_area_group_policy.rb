# frozen_string_literal: true

# TODO: Delegate checks to DataModelPolicy
class FocusAreaGroupPolicy < DataModelElementPolicy
  class Scope < Scope # rubocop:disable Style/Documentation
    def resolve
      if system_admin?
        scope.all
      else
        scope
          .joins(:data_model)
          .where(data_model: { workspace_id: current_user_available_workspace_ids })
      end
    end
  end
end
