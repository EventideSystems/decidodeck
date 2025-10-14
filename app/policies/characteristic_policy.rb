# frozen_string_literal: true

# Delegates checks to DataModelElementPolicy
class CharacteristicPolicy < DataModelElementPolicy
  class Scope < Scope # rubocop:disable Style/Documentation
    def resolve
      if system_admin?
        scope.all
      else
        scope
          .joins(focus_area: { focus_area_group: :data_model })
          .where(data_model: { workspace_id: current_user_available_workspace_ids })
      end.kept
    end
  end
end
