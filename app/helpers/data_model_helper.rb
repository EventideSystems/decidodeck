# frozen_string_literal: true

# Helper methods for presenting impact card data models
module DataModelHelper
  def data_model_filter_label(data_model)
    if data_model.workspace == current_workspace
      'Current Workspace'
    elsif data_model.public_model?
      'Public'
    else
      'Other Workspace'
    end
  end

  def data_model_filter_color(data_model)
    if data_model.workspace == current_workspace
      'bg-green-400 green-900'
    elsif data_model.public_model?
      'bg-red-400 red-900'
    else
      'bg-blue-400 blue-900'
    end
  end

  def data_model_status_color(data_model)
    case data_model.status.to_sym
    when :active then 'bg-green-400 green-900'
    when :draft then 'bg-yellow-400 yellow-900'
    when :archived then 'bg-gray-400 gray-900'
    else 'bg-gray-400 gray-900'
    end
  end

  def display_name(element)
    [element.code, element.short_name.presence || element.name].compact.join(' ')
  end
end
