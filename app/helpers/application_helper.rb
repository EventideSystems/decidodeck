# frozen_string_literal: true

# General helper methods for the application
module ApplicationHelper
  include Pagy::Frontend
  include TailwindClasses

  def application_name
    return current_theme_display_name if Rails.env.production?

    "#{current_theme_display_name} - #{Rails.env.titleize}"
  end

  # NOTE: Similar code in LandingPagesHelper#landing_pages_h1
  def brand_for_current_theme(logo_class: 'h-16 w-aut#o', title: nil, title_class: nil)
    brand_text = title || current_theme_display_name
    brand_text_class = merge_tailwind_class(
      'text-4xl font-bold tracking-tight text-zinc-950 sm:text-6xl dark:text-white', title_class
    )
    brand_image_path = brand_image_path_for_current_theme

    render 'branding', brand_image_path:, brand_text:, brand_text_class:, logo_class:
  end

  def link_to_registration(link_class: '')
    link_class = merge_tailwind_class(
      'text-lg font-semibold leading-6 text-white bg-teal-900 hover:bg-teal-700 px-4 py-2 rounded-sm', link_class
    )

    link_to(
      'Get Started',
      new_user_registration_path,
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
  def render_icon(icon, classes: 'w-6 h-6')
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

  # NOTE: Similar code in LandingPagesHelper#brand_image_path_for_current_theme
  # TODO: DRY this up, use a convention to locate images based on theme name
  def brand_image_path_for_current_theme
    case current_theme
    when :free_sdg
      'themes/free_sdg/brand.png'
    when :obsekio
      'logo-small.png'
    when :toolfor_systemic_change
      'logo-small.png'
    else
      'logo-small.png'
    end
  end

  def current_active_tab
    return nil unless controller.respond_to?(:active_tab_item)

    controller.active_tab_item
  end
end
