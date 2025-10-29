# frozen_string_literal: true

# Custom FormBuilder adding Tailwind classes to form fields.
class CustomFormBuilder < ActionView::Helpers::FormBuilder # rubocop:disable Metrics/ClassLength
  include TailwindSupport
  include MultiSelect

  def check_box(method, options = {}, checked_value = '1', unchecked_value = '0')
    merge_options = merge_options(method:, options:, default_class: CHECK_BOX_CLASS)
    wrap_field(method) { super(method, merge_options, checked_value, unchecked_value) }
  end

  def collection_select(method, collection, value_method, text_method, options = {}, html_options = {}) # rubocop:disable Metrics/ParameterLists
    merged_html_options = merge_options(method: method, options: html_options, default_class: SELECT_FIELD_CLASS)
    wrap_field(method, classes: 'mt-2 grid grid-cols-1') do
      super(method, collection, value_method, text_method, options, merged_html_options) +
        <<~HTML.html_safe # rubocop:disable Rails/OutputSafety
          <svg viewBox="0 0 16 16" fill="currentColor" data-slot="icon" aria-hidden="true" class="pointer-events-none col-start-1 row-start-1 mr-2 size-5 self-center justify-self-end text-gray-500 sm:size-4 dark:text-gray-400">
            <path d="M4.22 6.22a.75.75 0 0 1 1.06 0L8 8.94l2.72-2.72a.75.75 0 1 1 1.06 1.06l-3.25 3.25a.75.75 0 0 1-1.06 0L4.22 7.28a.75.75 0 0 1 0-1.06Z" clip-rule="evenodd" fill-rule="evenodd" />
          </svg>
        HTML
    end
  end

  # TODO: Add 'dark:[color-scheme:dark]' to the end of the class string to support dark mode.
  def date_field(method, options = {})
    # wrap_field(method) { super(method, merge_options(method:, options:)) }

    # TODO: Sketch of possible future implementation
    options = merge_options(method:, options:, default_class: DATE_FIELD_CLASS)

    @template.content_tag(:div, class: 'flex', data: { controller: 'date-select' }) do
      @template.concat(super(method, merge_options(method:, options:)))
      @template.concat(build_clear_button('date-select'))
    end
  end

  def email_field(method, options = {})
    wrap_field(method) { super(method, merge_options(method:, options:)) }
  end

  def label(method, content_or_options = nil, options = nil, &block)
    label_class_from_content = content_or_options.is_a?(Hash) ? content_or_options.delete(:class) : nil
    label_class_from_options = options.is_a?(Hash) ? options.delete(:class) : nil
    label_class = label_class_from_content || label_class_from_options

    tailwind_options = { class: merge_tailwind_class(LABEL_CLASS, label_class) }
    merge_options = options.is_a?(Hash) ? options.merge(tailwind_options) : tailwind_options

    super(method, content_or_options, merge_options, &block)
  end

  def number_field(method, options = {})
    wrap_field(method) { super(method, merge_options(method:, options:)) }
  end

  def password_field(method, options = {})
    wrap_field(method) { super(method, merge_options(method:, options:)) }
  end

  def rich_textarea(method, options = {})
    wrap_field(method) { super(method, merge_options(method:, options:)) }
  end

  def select(method, choices = nil, options = {}, html_options = {}, &block)
    merged_html_options = merge_options(method:, options: html_options, default_class: SELECT_FIELD_CLASS)

    wrap_field(method, classes: 'mt-2 grid grid-cols-1') do
      super(method, choices, options, merged_html_options, &block) +
        <<~HTML.html_safe # rubocop:disable Rails/OutputSafety
          <svg viewBox="0 0 16 16" fill="currentColor" data-slot="icon" aria-hidden="true" class="pointer-events-none col-start-1 row-start-1 mr-2 size-5 self-center justify-self-end text-gray-500 sm:size-4 dark:text-gray-400">
            <path d="M4.22 6.22a.75.75 0 0 1 1.06 0L8 8.94l2.72-2.72a.75.75 0 1 1 1.06 1.06l-3.25 3.25a.75.75 0 0 1-1.06 0L4.22 7.28a.75.75 0 0 1 0-1.06Z" clip-rule="evenodd" fill-rule="evenodd" />
          </svg>
        HTML
    end
  end

  def submit(value = nil, options = {})
    super(value, merge_options(method: nil, options:, default_class: SUBMIT_BUTTON_CLASS))
  end

  def text_area(method, options = {})
    wrap_field(method) { super(method, merge_options(method:, options:, default_class: TEXT_AREA_CLASS)) }
  end

  def text_field(method, options = {})
    wrap_field(method) { super(method, merge_options(method:, options:, default_class: TEXT_AREA_CLASS)) }
  end

  # def base_color_select(method, options = {}, html_options = {}, &block)
  #   field_classes = "#{SELECT_FIELD_CLASS} bg-#{@object.send(method)}-500"
  #   default_html_options = {
  #     class: build_default_field_class(field_classes, ERROR_BORDER_CLASS, method),
  #     data: BASE_COLOR_SELECT_DATA_ATTRIBUTES
  #   }
  #   merged_html_options = default_html_options.merge(html_options)

  #   @template.content_tag(:div, data: { controller: 'base-color-select' }) do
  #     select(method, OPTIONS_FOR_BASE_COLOR_SELECT, options, merged_html_options, &block)
  #   end
  # end

  private

  def append_error_message(object, method)
    return if object.blank?
    return unless object.errors[method].any?

    object.errors[method].each do |error_message|
      @template.concat(
        @template.content_tag(:div, class: ERROR_MESSAGE_CLASS) do
          error_message.html_safe # rubocop:disable Rails/OutputSafety
        end
      )
    end
  end

  def build_clear_button(stimulus_controller) # rubocop:disable Metrics/MethodLength
    <<~HTML.html_safe # rubocop:disable Rails/OutputSafety
      <button
        type="button"
        title="Clear filter"
        class="#{MULTI_SELECT_BUTTON_CLASS}"
        data-#{stimulus_controller}-target="clear"
      >
        <svg xmlns="http://www.w3.org/2000/svg" height="20px" viewBox="0 -960 960 960" width="20px" fill="currentColor">
          <path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"></path>
        </svg>
      </button>
    HTML
  end

  def build_default_field_class(base_class, error_class, method)
    return base_class if method.blank?
    return base_class if @object.blank?

    base_class + (@object.errors[method].any? ? " #{error_class}" : '')
  end

  def merge_options(method:, options: {}, default_class: TEXT_FIELD_CLASS, error_class: ERROR_BORDER_CLASS)
    options_class = options.delete(:class)
    text_field_class = merge_tailwind_class(default_class, options_class)

    base_options = { class: build_default_field_class(text_field_class, error_class, method) }
    base_options.merge(options)
  end

  def wrap_field(method, classes: 'mt-2')
    @template.content_tag(:div, class: classes) do
      @template.concat(yield)
      append_error_message(@object, method)
    end
  end
end
