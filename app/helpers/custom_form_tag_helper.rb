# frozen_string_literal: true

# Helper methods for form tags
module CustomFormTagHelper
  include TailwindSupport

  def base_color_select_tag(name, selected = 'red', options = {})
    default_opts = { class: base_color_select_class(selected),
                     data: BASE_COLOR_SELECT_DATA_ATTRIBUTES }

    content_tag(:div, data: { controller: 'base-color-select' }) do
      select_tag(name, options_for_select(OPTIONS_FOR_BASE_COLOR_SELECT, selected),
                 default_opts.merge(options))
    end
  end

  def custom_date_field_tag(name, value = nil, options = {})
    merged_options = merge_options(options: options, default_class: DATE_FIELD_CLASS)
    merged_options[:data] = (merged_options[:data] || {}).merge({ date_select_target: 'date' })

    content_tag(:div, class: 'flex', data: { controller: 'date-select' }) do
      concat(date_field_tag(name, value, merged_options))
      concat(build_clear_button('date-select'))
    end
  end

  def custom_label_tag(name = nil, content_or_options = nil, options = {}, &block)
    default_opts = { class: "#{LABEL_CLASS} mt-2" }
    label_tag(name, content_or_options, default_opts.merge(options), &block)
  end

  def custom_text_area_tag(name, content = nil, options = {})
    default_opts = { class: "#{TEXT_AREA_CLASS} mt-2" }

    text_area_tag(name, content, default_opts.merge(options))
  end

  def custom_text_field_tag(name, value = nil, options = {})
    default_class = "#{TEXT_FIELD_CLASS} mt-2"

    # content_tag(:div) do
    text_field_tag(name, value, merge_options(options:, default_class:))
    # end
  end

  def custom_select_tag(name, option_tags = nil, options = {})
    content_tag(:div, class: 'mt-2 grid grid-cols-1') do
      concat(select_tag(name, option_tags, merge_options(options:, default_class: SELECT_FIELD_CLASS)))
      concat(
        <<~HTML.html_safe # rubocop:disable Rails/OutputSafety
          <svg viewBox="0 0 16 16" fill="currentColor" data-slot="icon" aria-hidden="true" class="pointer-events-none col-start-1 row-start-1 mr-2 size-5 self-center justify-self-end text-gray-500 sm:size-4 dark:text-gray-400">
            <path d="M4.22 6.22a.75.75 0 0 1 1.06 0L8 8.94l2.72-2.72a.75.75 0 1 1 1.06 1.06l-3.25 3.25a.75.75 0 0 1-1.06 0L4.22 7.28a.75.75 0 0 1 0-1.06Z" clip-rule="evenodd" fill-rule="evenodd" />
          </svg>
        HTML
      )
    end
  end

  def custom_multi_select_tag(name, choices = nil, options = {}, html_options = {}, &block) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    placeholder = options.delete(:placeholder) || 'Select multiple options...'
    toggleCountText = multi_select_toggle_count_text(name, options) # rubocop:disable Naming/VariableName
    hs_select = CustomFormBuilder::MULTI_SELECT_DEFAULT_HS_SELECT.merge(placeholder:, toggleCountText:).to_json # rubocop:disable Naming/VariableName
    choices = '<option disabled="">No options available</option>'.html_safe if choices.empty?
    options[:multiple] = true
    data_options = html_options.delete(:data) || {}
    html_options[:data] = data_options.merge({ multi_select_target: 'select', hs_select: })
    html_options[:class] = 'hidden'

    content_tag(:div, class: 'flex', data: { controller: 'multi-select' }) do
      concat(select_tag(name, choices, options.merge(html_options), &block))
      concat(build_clear_button('multi-select'))
    end
  end

  private

  def multi_select_toggle_count_text(method, options = {})
    base_text = options[:base_text] || method.to_s.titleize.downcase.singularize
    pluralized_text = base_text.pluralize

    if pluralized_text.ends_with?('ies')
      "#{base_text}/#{pluralized_text}"
    else
      diff = pluralized_text.gsub(base_text, '')

      "#{base_text}(#{diff}) selected"
    end
  end

  def base_color_select_class(selected)
    "#{SELECT_FIELD_CLASS} bg-#{selected}-500"
  end

  # SMELL: Duplicated in app/helpers/custom_form_tag_helper.rb
  def build_clear_button(stimulus_controller) # rubocop:disable Metrics/MethodLength
    <<~HTML.html_safe # rubocop:disable Rails/OutputSafety
        <button
        type="button"
        title="Clear filter"
        class="mt-2 ml-1 w-auto h-auto px-1.5 border border-gray-300 rounded-lg dark:border-gray-600 rounded-md text-gray-500 dark:text-neutral-500 flex items-center justify-center"
        data-#{stimulus_controller}-target="clear"
      >
        <svg xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="currentColor">
          <path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"></path>
        </svg>
      </button>
    HTML
  end

  def merge_options(options: {}, default_class: TEXT_FIELD_CLASS)
    options_class = options.delete(:class)
    text_field_class = merge_tailwind_class(default_class, options_class)

    base_options = { class: text_field_class }
    base_options.merge(options)
  end
end
