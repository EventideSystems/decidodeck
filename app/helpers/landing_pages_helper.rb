# frozen_string_literal: true

# Helper methods related to landing pages and other pages accessible without logging in (privacy, terms, etc)
module LandingPagesHelper
  def landing_pages_h1(title: nil, title_class: nil)
    brand_text = title || current_theme_display_name
    brand_text_class = merge_tailwind_class(
      'text-4xl font-bold tracking-tight text-zinc-50 sm:text-6xl', title_class
    )
    brand_image_path = current_theme_logo

    render 'branding', brand_image_path:, brand_text:, brand_text_class:, logo_class: 'h-16 w-auto'
  end

  def landing_pages_top_level_link_to(text, url, options = {})
    link_to(
      text,
      url,
      options.merge(
        class: "text-lg font-semibold leading-6 text-white px-4 py-2 rounded-s #{button_bg_class_for_current_theme}"
      )
    )
  end

  def landing_pages_form_submit(form, name)
    form.submit(name, class: button_bg_class_for_current_theme)
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

  def landing_pages_form_secondary_link(text, url)
    link_to(
      text,
      url,
      class: 'text-sm/6 font-semibold text-gray-100'
    )
  end

  def document_bg_class_for_current_theme
    case current_theme
    when :free_sdg
      'bg-amber-900'
    when :obsekio
      'bg-teal-900'
    when :toolfor_systemic_change
      'bg-teal-900'
    else
      'bg-teal-900'
    end
  end

  def link_to_socials_for_current_theme(name, path, icon)
    link_to path, target: '_blank', class: social_icons_class_for_current_theme, rel: 'noopener' do
      concat(content_tag(:span, class: 'sr-only') { name })
      concat(render_icon(icon))
    end
  end

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

  private

  def button_bg_class_for_current_theme
    case current_theme
    when :free_sdg
      'bg-amber-900 hover:bg-amber-700 dark:bg-amber-900 dark:hover:bg-amber-700'
    when :obsekio
      'bg-teal-900 hover:bg-teal-700 dark:bg-teal-900 dark:hover:bg-teal-700'
    when :toolfor_systemic_change
      'bg-teal-900 hover:bg-teal-700 dark:bg-teal-900 dark:hover:bg-teal-700'
    else
      'bg-teal-900 hover:bg-teal-700 dark:bg-teal-900 dark:hover:bg-teal-700'
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
