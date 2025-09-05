# frozen_string_literal: true

# Helper methods related to themes
module ThemesHelper
  def brand_for_current_theme(logo_class: 'h-16 w-auto', title: nil, title_class: nil)
    brand_text = title || current_theme_display_name
    brand_text_class = merge_tailwind_class(
      'text-4xl font-bold tracking-tight text-zinc-950 sm:text-6xl dark:text-white', title_class
    )
    brand_image_path = brand_text_class_for_current_theme

    render 'branding', brand_image_path:, brand_text:, brand_text_class:, logo_class:
  end

  def big_button_link_to_for_current_theme(text, url, options = {})
    link_to(
      text,
      url,
      options.merge(
        class: "text-lg font-semibold leading-6 text-white px-4 py-2 rounded-s #{button_bg_class_for_current_theme}"
      )
    )
  end

  def landing_page_body_bg_class_for_current_theme
    case current_theme
    when :free_sdg
      'bg-amber-800'
    when :obsekio
      'bg-teal-800'
    when :toolfor_systemic_change
      'bg-teal-800'
    else
      'bg-teal-800'
    end
  end

  def document_bg_class_for_current_theme
    case current_theme
    when :free_sdg
      'bg-amber-900'
    when :obsekio
      'bg-teal-900 '
    when :toolfor_systemic_change
      'bg-teal-900 '
    else
      'bg-teal-900 '
    end
  end

  def link_to_socials_for_current_theme(name, path, icon)
    link_to path, target: '_blank', class: social_icons_class_for_current_theme, rel: 'noopener' do
      concat(content_tag(:span, class: 'sr-only') { name })
      concat(render_icon(icon))
    end
  end

  private

  def brand_text_class_for_current_theme
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

  def button_bg_class_for_current_theme
    case current_theme
    when :free_sdg
      'bg-amber-900 hover:bg-amber-700'
    when :obsekio
      'bg-teal-900 hover:bg-teal-700'
    when :toolfor_systemic_change
      'bg-teal-900 hover:bg-teal-700'
    else
      'bg-teal-900 hover:bg-teal-700'
    end
  end

  def social_icons_class_for_current_theme
    case current_theme
    when :free_sdg
      'text-gray-200 hover:text-gray-300'
    when :obsekio
      'text-gray-500 hover:text-gray-400'
    when :toolfor_systemic_change
      'text-gray-500 hover:text-gray-400'
    else
      'text-gray-500 hover:text-gray-400'
    end
  end
end
