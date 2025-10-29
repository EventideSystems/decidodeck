# frozen_string_literal: true

# Support for setting the active menu item in a controller
module ActiveMenuItem
  extend ActiveSupport::Concern

  def active_menu_item
    self.class.instance_variable_get(:@active_menu_item)
  end

  class_methods do
    def menu_item(name)
      instance_variable_set(:@active_menu_item, name)
    end
  end

  delegate :menu_item, to: :class
end
