# frozen_string_literal: true

# Custom breadcrumbs builder styled with Tailwind CSS
class TailwindBreadcrumbsBuilder < BreadcrumbsOnRails::Breadcrumbs::Builder
  attr_reader :context, :elements

  def render
    context.content_tag(:nav, class: 'flex', aria: { label: 'Breadcrumb' }) do
      context.content_tag(:ol, class: 'flex items-center space-x-1 text-sm', role: 'list') do
        render_elements_with_separators
      end
    end
  end

  private

  BASE_CLASSES = 'truncate transition-colors duration-200'
  FIRST_ELEMENT_CLASSES = 'flex items-center text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200 font-medium' # rubocop:disable Layout/LineLength

  def render_elements_with_separators
    return ''.html_safe if elements.empty?

    output = render_first_element(elements.first)

    elements[1..].each do |element|
      output += render_separator
      output += render_element(element)
    end

    output.html_safe # rubocop:disable Rails/OutputSafety
  end

  def render_first_element(element) # rubocop:disable Metrics/MethodLength
    context.content_tag(:li, class: 'flex items-center') do
      context.content_tag(:h1) do
        context.link_to(
          compute_name(element),
          compute_path(element),
          element.options.merge(
            class: "#{BASE_CLASSES} #{FIRST_ELEMENT_CLASSES}"
          )
        )
      end
    end
  end

  def render_element(element)
    current = context.current_page?(compute_path(element))

    context.content_tag(:li, class: 'flex items-center') do
      link_or_text(element, current)
    end
  end

  def render_separator
    context.content_tag(:li, class: 'flex items-center', aria: { hidden: 'true' }) do
      divider
    end
  end

  def divider
    <<~SVG.html_safe # rubocop:disable Rails/OutputSafety
      <svg viewBox="0 0 20 20" fill="currentColor" aria-hidden="true" class="size-5 shrink-0 text-gray-300 dark:text-gray-600">
        <path d="M5.555 17.776l8-16 .894.448-8 16-.894-.448z" />
      </svg>
    SVG
  end

  def link_or_text(element, current)
    if current
      render_text(element)
    else
      render_link(element)
    end
  end

  def render_text(element)
    context.content_tag(
      :span, compute_name(element),
      class: "#{BASE_CLASSES} text-gray-900 dark:text-gray-100 font-medium",
      aria: { current: 'page' }
    )
  end

  def render_link(element)
    context.link_to(
      compute_name(element),
      compute_path(element),
      element.options.merge(
        class: "#{BASE_CLASSES} text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200"
      )
    )
  end
end
