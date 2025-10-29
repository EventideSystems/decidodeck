# frozen_string_literal: true

# Helper methods for the home page and related views
module HomeHelper
  def multi_select_options_for_artifact_types(artifact_types = [], selected_types = nil)
    options_for_select(artifact_types_container(artifact_types), selected_types)
  end

  private

  def artifact_types_container(artifact_types)
    artifact_types.map do |type|
      klass = type.constantize
      display_name = klass.respond_to?(:model_name) ? klass.model_name.human : type
      [display_name, type]
    rescue NameError
      [type, type]
    end
  end
end
