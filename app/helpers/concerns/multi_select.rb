# frozen_string_literal: true

require 'tailwind_merge'

# Basic multi-select functionality for forms
module MultiSelect # rubocop:disable Metrics/ModuleLength
  extend ActiveSupport::Concern

  include TailwindSupport

  attr_reader :template

  MULTI_SELECT_OPTION_TEMPLATE = <<~HTML
    <div class="flex justify-between items-center w-full">
      <div class="flex">
        <div data-icon></div>
        <div data-title></div>
      </div>
      <div data-select-icon class="hidden hs-selected:block">
        <svg
          class="shrink-0 size-3.5 text-blue-600 dark:text-blue-500 "
          xmlns="http:.w3.org/2000/svg"
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        >
          <polyline points="20 6 9 17 4 12"/>
        </svg>
      </div>
    </div>
  HTML

  MULTI_SELECT_TOGGLE_CLASSES = %w[
    hs-select-disabled:pointer-events-none
    hs-select-disabled:opacity-50
    relative
    py-1.5
    px-3
    pe-9
    flex
    text-nowrap
    w-auto
    cursor-pointer
    bg-white
    border
    border-gray-300
    rounded-lg
    text-start
    text-sm
    focus:ring-2
    focus:ring-blue-500
    before:absolute
    before:inset-0
    before:z-1
    dark:bg-neutral-900
    dark:border-gray-600
    dark:text-neutral-400
  ].join(' ').freeze

  MULTI_SELECT_DROPDOWN_CLASSES = %w[
    z-50
    w-full
    max-h-100
    p-1
    space-y-0.5
    bg-white
    border
    border-gray-200
    rounded-lg
    overflow-hidden
    overflow-y-auto
    [&::-webkit-scrollbar]:w-2
    [&::-webkit-scrollbar-thumb]:rounded-full
    [&::-webkit-scrollbar-track]:bg-gray-100
    [&::-webkit-scrollbar-thumb]:bg-gray-300
    dark:[&::-webkit-scrollbar-track]:bg-neutral-700
    dark:[&::-webkit-scrollbar-thumb]:bg-neutral-500
    dark:bg-neutral-900
    dark:border-neutral-700
  ].join(' ').freeze

  MULTI_SELECT_OPTION_CLASSES = %w[
    hs-selected:block
    py-2
    px-4
    w-full
    text-sm
    text-gray-800
    cursor-pointer
    hover:bg-gray-100
    rounded-lg
    focus:outline-hidden
    focus:bg-gray-100
    dark:bg-neutral-900
    dark:hover:bg-neutral-800
    dark:text-neutral-200
    dark:focus:bg-neutral-800
  ].join(' ').freeze

  MULTI_SELECT_EXTRA_MARKUP = <<~HTML
    <div class="absolute top-5 end-4 -translate-y-1/2">
      <svg
        class="shrink-0 size-3.5 text-gray-500 dark:text-neutral-500 "
        xmlns="http://www.w3.org/2000/svg"
        width="20"
        height="2"
        viewBox="0 0 20 20"
        fill="none"
        stroke="currentColor"
        stroke-width="2"
        stroke-linecap="round"
        stroke-linejoin="round"
      >
        <path d="m7 15 5 5 5-5"/><path d="m7 9 5-5 5 5"/>
      </svg>
    </div>
  HTML

  MULTI_SELECT_BUTTON_CLASS = %w[
    ml-1
    w-auto
    h-auto
    px-1.5
    border
    border-gray-300
    rounded-lg
    dark:border-gray-600
    rounded-md
    text-gray-500
    dark:text-neutral-500
    flex
    items-center
    justify-center
  ].join(' ')

  MULTI_SELECT_DEFAULT_HS_SELECT = {
    placeholder: 'Select multiple options...',
    toggleTag: '<button type="button" aria-expanded="false"></button>',
    toggleClasses: MULTI_SELECT_TOGGLE_CLASSES,
    toggleSeparators: {
      items: ', ',
      betweenItemsAndCounter: ' '
    },
    toggleCountText: 'selected',
    toggleCountTextMinItems: 1,
    toggleCountTextMode: 'nItemsAndCount',
    dropdownClasses: MULTI_SELECT_DROPDOWN_CLASSES,
    optionClasses: MULTI_SELECT_OPTION_CLASSES,
    optionTemplate: MULTI_SELECT_OPTION_TEMPLATE,
    extraMarkup: MULTI_SELECT_EXTRA_MARKUP
  }.freeze

  def multi_select(method, choices = nil, options = {}, html_options = {}, &block) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    placeholder = options.delete(:placeholder) || 'Select multiple options...'
    # rubocop:disable Naming/VariableName
    toggleCountText = build_toggle_count_text(method, options)
    base_hs_select = MULTI_SELECT_DEFAULT_HS_SELECT.merge(placeholder:, toggleCountText:)
    if options[:toggle_classes]
      base_hs_select[:toggleClasses] =
        tw(base_hs_select[:toggleClasses], options[:toggle_classes])
    end
    hs_select = base_hs_select.to_json
    # rubocop:enable Naming/VariableName

    choices = '<option disabled="">No options available</option>'.html_safe if choices.empty?
    options[:multiple] = true
    data_options = html_options.delete(:data) || {}
    html_options[:data] = data_options.merge({ multi_select_target: 'select', hs_select: })
    html_options[:class] = 'hidden'

    template.content_tag(:div, class: 'flex', data: { controller: 'multi-select' }) do
      template.concat(ActionView::Helpers::Tags::Select.new(
        object_name, method, template, choices, options, html_options, &block
      ).render)

      template.concat(build_clear_button('multi-select'))
    end
  end

  private

  # SMELL: Duplicated in app/helpers/custom_form_tag_helper.rb and app/helpers/custom_form_builder.rb
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

  def build_toggle_count_text(method, options = {})
    options[:base_text] || method.to_s.titleize.singularize
  end
end
