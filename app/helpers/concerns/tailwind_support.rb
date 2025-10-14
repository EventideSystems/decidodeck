# frozen_string_literal: true

require 'tailwind_merge'

# Common Tailwind CSS classes
module TailwindSupport
  extend ActiveSupport::Concern

  included do
    def merge_tailwind_class(base_classes, override_classes)
      TailwindMerge::Merger.new.merge([base_classes, override_classes])
    end

    def tw(*classes)
      TailwindMerge::Merger.new.merge(classes.join(' '))
    end
  end

  BORDER_CLASS = 'border-zinc-950/10 dark:border-white/10'

  DANGER_ZONE_BUTTON_CLASS = <<~CSS.squish
    rounded-md
    border
    dark:border-gray-600
    bg-zinc-950
    dark:bg-gray-800
    px-3
    py-2
    text-sm
    font-semibold
    text-white
    dark:text-red-600
    shadow-sm
    flex
    items-center
    space-x-2
    text-red-600
    hover:bg-red-500
    dark:hover:bg-red-500
    dark:border:hover:bg-red-500
    hover:text-white
    dark:hover:text-white
  CSS

  CHECK_BOX_CLASS = 'h-4 w-4 rounded-sm border-gray-300 text-blue-600 focus:outline-blue-600'

  COMMON_FIELD_CLASS = 'block w-full rounded-md bg-white px-3 py-1.5 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 placeholder:text-gray-400 focus:outline-2 focus:-outline-offset-2 focus:outline-blue-600 sm:text-sm/6 dark:bg-white/5 dark:text-white dark:outline-white/10 dark:placeholder:text-gray-500 dark:focus:outline-blue-500' # rubocop:disable Layout/LineLength

  SELECT_FIELD_CLASS = 'col-start-1 row-start-1 w-full appearance-none rounded-md bg-white py-1.5 pr-8 pl-3 text-base text-gray-900 outline-1 -outline-offset-1 outline-gray-300 focus:outline-2 focus:-outline-offset-2 focus:outline-blue-600 sm:text-sm/6 dark:bg-white/5 dark:text-white dark:outline-white/10 dark:*:bg-gray-800 dark:focus:outline-blue-500' # rubocop:disable Layout/LineLength

  SUBMIT_BUTTON_CLASS = <<~CSS.squish
    rounded-md
    bg-zinc-950
    dark:bg-zinc-600
    px-3
    py-2
    text-sm
    font-semibold
    text-white
    shadow-sm
    hover:bg-zinc-400
    focus-visible:outline
    focus-visible:outline-2
    focus-visible:outline-offset-2
    focus-visible:outline-zinc-500
    cursor-pointer
  CSS

  TEXT_FIELD_CLASS = COMMON_FIELD_CLASS
  TEXT_AREA_CLASS = COMMON_FIELD_CLASS
  DATE_FIELD_CLASS = "#{COMMON_FIELD_CLASS} mt-2 dark:[color-scheme:dark]".freeze

  ERROR_BORDER_CLASS = 'border-2 border-red-500'
  ERROR_MESSAGE_CLASS = 'h-2 mt-2 mb-4 text-xs text-red-500 dark:text-red-500'
  LABEL_CLASS = 'block text-sm/6 font-medium text-gray-900 dark:text-white'
end
