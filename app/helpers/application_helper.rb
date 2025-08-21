# frozen_string_literal: true

# General helper methods for the application
module ApplicationHelper
  include Pagy::Frontend
  include TailwindClasses

  def application_title
    return 'Obsekio' if Rails.env.production?

    "Obsekio - #{Rails.env.titleize}"
  end

  def render_branding
    render 'branding'
  end

  def page_header_tag(title)
    content_tag :h1, title, class: 'text-2xl/8 font-semibold text-zinc-950 sm:text-xl/8 dark:text-white'
  end

  def horizontal_rule(options = {})
    options[:class] = merge_tailwind_class("w-full border-t #{BORDER_CLASS}", options[:class])
    options[:role] = 'presentation'

    content_tag(:hr, nil, options)
  end

  # Render an SVG icon from views/icons
  # Source: https://www.writesoftwarewell.com/how-to-render-svg-icons-in-rails
  def render_icon(icon, classes: '')
    render "icons/#{icon}", classes:
  end

  def render_sidebar_item(title:, path:, icon:, active_group:, classes: '', count: nil) # rubocop:disable Metrics/ParameterLists
    active = active_group == controller.active_sidebar_item

    render 'layouts/shared/sidebar_item', title:, path:, icon:, active:, classes:, count:
  end

  def render_tab_item(title:, path:, active_tab:, classes: '')
    active = active_tab == current_active_tab

    render 'layouts/shared/tab_item', title:, path:, active:, classes:
  end

  def definition_list_element(term, definition)
    render 'application/definition_list_element', term: term, definition: definition
  end

  def html_lang
    I18n.locale == I18n.default_locale ? 'en' : I18n.locale.to_s
  end

  private

  def current_active_tab
    return nil unless controller.respond_to?(:active_tab_item)

    controller.active_tab_item
  end
end
