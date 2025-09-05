# frozen_string_literal: true

# General helper methods for the application
module ApplicationHelper
  include Pagy::Frontend
  include TailwindClasses

  def application_name
    return current_theme_display_name if Rails.env.production?

    "#{current_theme_display_name} - #{Rails.env.titleize}"
  end

  def link_to_registration(link_class: '')
    params = params&.key?(:theme) ? { theme: current_theme } : {}
    link_class = merge_tailwind_class(
      'text-lg font-semibold leading-6 text-white bg-teal-900 hover:bg-teal-700 px-4 py-2 rounded-sm', link_class
    )

    link_to(
      'Get Started',
      new_user_registration_path(params),
      class: link_class,
      data: { turbo: false }
    )
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

  # NOTE: Not currently in use
  def html_lang
    I18n.locale == I18n.default_locale ? 'en' : I18n.locale.to_s
  end

  private

  def current_active_tab
    return nil unless controller.respond_to?(:active_tab_item)

    controller.active_tab_item
  end
end
