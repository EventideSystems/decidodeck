# frozen_string_literal: true

module NotificationHelper # rubocop:disable Style/Documentation
  # rubocop:disable Layout/LineLength
  def notification_classes(type) # rubocop:disable Metrics/MethodLength
    base_classes = 'fixed bottom-4 right-4 z-50 max-w-sm w-full transform transition-all duration-300 ease-in-out translate-x-full opacity-0'

    type_classes = case type.to_s
                   when 'notice', 'success'
                     'bg-green-50 dark:bg-green-900/50 border-l-4 border-green-400 text-green-700 dark:text-green-200'
                   when 'alert', 'error'
                     'bg-red-50 dark:bg-red-900/50 border-l-4 border-red-400 text-red-700 dark:text-red-200'
                   when 'warning'
                     'bg-yellow-50 dark:bg-yellow-900/50 border-l-4 border-yellow-400 text-yellow-700 dark:text-yellow-200'
                   when 'info'
                     'bg-blue-50 dark:bg-blue-900/50 border-l-4 border-blue-400 text-blue-700 dark:text-blue-200'
                   else
                     'bg-gray-50 dark:bg-gray-800 border-l-4 border-gray-400 text-gray-700 dark:text-gray-200'
                   end

    "#{base_classes} #{type_classes}"
  end
  # rubocop:enable Layout/LineLength

  # rubocop:disable Layout/LineLength
  def notification_icon(type) # rubocop:disable Metrics/MethodLength
    case type.to_s
    when 'notice', 'success'
      '<svg class="h-5 w-5 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
      </svg>'
    when 'alert', 'error'
      '<svg class="h-5 w-5 text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"/>
      </svg>'
    when 'warning'
      '<svg class="h-5 w-5 text-yellow-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z"/>
      </svg>'
    when 'info'
      '<svg class="h-5 w-5 text-blue-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
      </svg>'
    else
      '<svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
      </svg>'
    end.html_safe # rubocop:disable Rails/OutputSafety
  end
  # rubocop:enable Layout/LineLength

  def should_use_browser_notification?(type)
    # Use browser notifications for important messages
    %w[error alert warning].include?(type.to_s)
  end

  def notification_duration(type)
    # Keep error messages visible longer
    case type.to_s
    when 'error', 'alert'
      8000  # 8 seconds
    when 'warning'
      6000  # 6 seconds
    else
      5000  # 5 seconds
    end
  end
end
