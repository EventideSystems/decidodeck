import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notification"
export default class extends Controller {
  static targets = ["container"]
  static values = { 
    type: String,
    message: String,
    duration: { type: Number, default: 5000 },
    dismissible: { type: Boolean, default: true },
    allowBrowserNotification: { type: Boolean, default: true }
  }

  connect() {
    this.show()
    if (this.durationValue > 0) {
      this.timeoutId = setTimeout(() => {
        this.hide()
      }, this.durationValue)
    }

    // Try browser notification if enabled and for important messages
    if (this.allowBrowserNotificationValue && this.shouldShowBrowserNotifications()) {
      this.tryBrowserNotification()
    }
  }

  disconnect() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }

  show() {
    // Animate in from the right
    this.element.classList.remove('translate-x-full', 'opacity-0')
    this.element.classList.add('translate-x-0', 'opacity-100')
  }

  hide() {
    // Animate out to the right
    this.element.classList.remove('translate-x-0', 'opacity-100')
    this.element.classList.add('translate-x-full', 'opacity-0')
    
    // Remove element after animation
    setTimeout(() => {
      if (this.element.parentNode) {
        this.element.remove()
      }
    }, 300)
  }

  dismiss() {
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
    this.hide()
  }

  // Browser notification methods with fallbacks
  async tryBrowserNotification() {
    if (!this.isBrowserNotificationSupported()) {
      console.log('Browser notifications not supported, using in-app notification only')
      return
    }

    const permission = await this.requestNotificationPermission()
    
    if (permission === 'granted') {
      this.showBrowserNotification()
    } else if (permission === 'default') {
      // Show permission prompt for important notifications
      this.showPermissionPrompt()
    }
  }

  isBrowserNotificationSupported() {
    return 'Notification' in window
  }

  async requestNotificationPermission() {
    if (!this.isBrowserNotificationSupported()) {
      return 'denied'
    }

    // If permission is already granted or denied, return current status
    if (Notification.permission !== 'default') {
      return Notification.permission
    }

    // Request permission
    try {
      const permission = await Notification.requestPermission()
      return permission
    } catch (error) {
      console.error('Error requesting notification permission:', error)
      return 'denied'
    }
  }

  showBrowserNotification() {
    if (Notification.permission === 'granted') {
      const notification = new Notification(this.getNotificationTitle(), {
        body: this.messageValue,
        icon: this.getNotificationIcon(),
        badge: '/icon.png',
        tag: `decidodeck-${this.typeValue}`, // Prevents duplicate notifications
        requireInteraction: this.typeValue === 'error', // Keep error notifications visible
        silent: false
      })

      // Auto-close browser notification after duration
      if (this.durationValue > 0) {
        setTimeout(() => {
          notification.close()
        }, this.durationValue)
      }

      // Handle notification click
      notification.onclick = () => {
        window.focus()
        notification.close()
        this.handleNotificationClick()
      }
    }
  }

  getNotificationTitle() {
    const titles = {
      'success': '✅ Success - Decidodeck',
      'notice': 'ℹ️ Notice - Decidodeck',
      'error': '❌ Error - Decidodeck',
      'alert': '⚠️ Alert - Decidodeck',
      'warning': '⚠️ Warning - Decidodeck',
      'info': 'ℹ️ Info - Decidodeck'
    }
    return titles[this.typeValue] || 'Decidodeck Notification'
  }

  getNotificationIcon() {
    // Use the same icon for all notifications (your app icon)
    return '/icon.png'
  }

  showPermissionPrompt() {
    // Don't show if user previously dismissed
    if (localStorage.getItem('decidodeck_notification_prompt_dismissed') === 'true') {
      return
    }

    // Don't show if prompt already exists
    if (document.querySelector('[data-notification-prompt]')) {
      return
    }

    const prompt = document.createElement('div')
    prompt.setAttribute('data-notification-prompt', '')
    prompt.className = 'fixed bottom-20 right-4 bg-blue-50 dark:bg-blue-900/50 border border-blue-200 dark:border-blue-800 rounded-lg p-3 text-sm shadow-lg z-40 max-w-sm'
    prompt.innerHTML = `
      <div class="flex items-start space-x-2">
        <svg class="h-4 w-4 text-blue-500 mt-0.5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-5 5-5-5h5v-6a7.5 7.5 0 1 0-15 0v6h5l-5 5-5-5h5V7a12 12 0 1 1 24 0v10z"/>
        </svg>
        <div class="flex-1">
          <div class="text-blue-700 dark:text-blue-200 font-medium mb-1">Enable Desktop Notifications?</div>
          <div class="text-blue-600 dark:text-blue-300 text-xs mb-2">Get notified even when Decidodeck isn't active</div>
          <div class="flex space-x-2">
            <button data-action="click->notification#enableBrowserNotifications" 
                    class="text-xs bg-blue-600 text-white px-2 py-1 rounded-sm hover:bg-blue-700 transition-colors">
              Enable
            </button>
            <button data-action="click->notification#dismissPermissionPrompt"
                    class="text-xs text-blue-600 dark:text-blue-400 hover:text-blue-800 dark:hover:text-blue-200">
              Not now
            </button>
          </div>
        </div>
        <button data-action="click->notification#dismissPermissionPrompt"
                class="text-gray-400 hover:text-gray-600 dark:hover:text-gray-200 shrink-0">
          <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
          </svg>
        </button>
      </div>
    `
    document.body.appendChild(prompt)

    // Auto-remove prompt after 15 seconds
    setTimeout(() => {
      if (prompt.parentNode) {
        prompt.remove()
      }
    }, 15000)
  }

  async enableBrowserNotifications() {
    const permission = await this.requestNotificationPermission()
    if (permission === 'granted') {
      this.showBrowserNotification()
      localStorage.setItem('decidodeck_browser_notifications', 'enabled')
    }
    this.dismissPermissionPrompt()
  }

  dismissPermissionPrompt() {
    const prompt = document.querySelector('[data-notification-prompt]')
    if (prompt) {
      prompt.remove()
    }
    localStorage.setItem('decidodeck_notification_prompt_dismissed', 'true')
  }

  handleNotificationClick() {
    // Focus window when notification is clicked
    if (window.focus) {
      window.focus()
    }
  }

  shouldShowBrowserNotifications() {
    // Don't show if user previously dismissed the prompt
    if (localStorage.getItem('decidodeck_notification_prompt_dismissed') === 'true') {
      return localStorage.getItem('decidodeck_browser_notifications') === 'enabled'
    }
    
    // Show browser notifications for important message types
    return ['error', 'alert', 'warning'].includes(this.typeValue)
  }
}
