import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="drawer"
export default class extends Controller {
  static targets = ["panel", "overlay", "tab", "icon", "content"]

  connect() {
    console.log("🎯 Drawer controller connected!")
    
    // Log what targets are found
    console.log("Available targets:", {
      panel: this.hasPanelTarget ? "✅" : "❌",
      overlay: this.hasOverlayTarget ? "✅" : "❌", 
      tab: this.hasTabTarget ? "✅" : "❌",
      icon: this.hasIconTarget ? "✅" : "❌",
      content: this.hasContentTarget ? "✅" : "❌"
    })
    
    // Make sure drawer starts closed
    if (this.hasPanelTarget) {
      this.panelTarget.classList.add("translate-x-full")
      this.panelTarget.classList.remove("translate-x-0")
    }
    
    // Set initial icon direction (arrow pointing left when closed)
    this.updateIconDirection(false)
    
    // Add keyboard event listener for ESC key
    this.keydownHandler = this.handleKeydown.bind(this)
    document.addEventListener("keydown", this.keydownHandler)
  }

  disconnect() {
    // Clean up keyboard event listener
    document.removeEventListener("keydown", this.keydownHandler)
  }

  handleKeydown(event) {
    // Close drawer when ESC key is pressed
    if (event.key === "Escape" || event.keyCode === 27) {
      const isOpen = this.hasPanelTarget && this.panelTarget.classList.contains("translate-x-0")
      if (isOpen) {
        console.log("⌨️ ESC key pressed - closing drawer")
        this.close()
      }
    }
  }

  toggle() {
    console.log("🔄 Toggle button clicked!")
    
    if (!this.hasPanelTarget) {
      console.error("❌ No panel target found")
      return
    }
    
    const isOpen = this.panelTarget.classList.contains("translate-x-0")
    console.log("Current state:", isOpen ? "OPEN" : "CLOSED")
    
    if (isOpen) {
      this.close()
    } else {
      this.open()
    }
  }

  open() {
    console.log("📂 Opening drawer...")
    
    // Slide drawer in
    this.panelTarget.classList.remove("translate-x-full")
    this.panelTarget.classList.add("translate-x-0")
    
    // Show overlay
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.remove("opacity-0", "pointer-events-none")
      this.overlayTarget.classList.add("opacity-100", "pointer-events-auto")
    }
    
    // Apply blur to main content
    if (this.hasContentTarget) {
      this.contentTarget.style.filter = "blur(0.5px)"
      this.contentTarget.style.transition = "filter 300ms ease"
    }
    
    // Update icon direction (arrow pointing right when open)
    this.updateIconDirection(true)
    
    console.log("✅ Drawer opened")
  }

  close() {
    console.log("📁 Closing drawer...")
    
    // Slide drawer out
    this.panelTarget.classList.remove("translate-x-0")
    this.panelTarget.classList.add("translate-x-full")
    
    // Hide overlay  
    if (this.hasOverlayTarget) {
      this.overlayTarget.classList.remove("opacity-100", "pointer-events-auto")
      this.overlayTarget.classList.add("opacity-0", "pointer-events-none")
    }
    
    // Remove blur from main content
    if (this.hasContentTarget) {
      this.contentTarget.style.filter = "none"
    }
    
    // Update icon direction (arrow pointing left when closed)
    this.updateIconDirection(false)
    
    console.log("✅ Drawer closed")
  }

  closeOnOverlay() {
    console.log("📱 Overlay clicked - closing drawer")
    this.close()
  }

  updateIconDirection(isOpen) {
    if (!this.hasIconTarget) {
      console.log("⚠️ No icon target found for direction update")
      return
    }

    // Get the path element inside the SVG
    const pathElement = this.iconTarget.querySelector('path')
    if (!pathElement) {
      console.log("⚠️ No path element found in icon")
      return
    }

    if (isOpen) {
      // Arrow pointing right (when open, to indicate "close")
      pathElement.setAttribute('d', 'M9 5l7 7-7 7')
      console.log("🔄 Icon updated: arrow pointing right (close)")
    } else {
      // Arrow pointing left (when closed, to indicate "open")
      pathElement.setAttribute('d', 'M15 19l-7-7 7-7')
      console.log("🔄 Icon updated: arrow pointing left (open)")
    }
  }
}
