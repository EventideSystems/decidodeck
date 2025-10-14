import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["button", "menu"]

  connect() {
    this.outsideClickListener = this.outsideClick.bind(this)
  }

  disconnect() {
    document.removeEventListener("click", this.outsideClickListener)
  }

  toggle(event) {
    console.log("Dropdown toggle clicked", event)
    event.preventDefault()
    event.stopPropagation()
    
    if (this.menuTarget.classList.contains("hidden")) {
      this.open()
    } else {
      this.close()
    }
  }

  open() {
    this.menuTarget.classList.remove("hidden")
    this.buttonTarget.setAttribute("aria-expanded", "true")
    document.addEventListener("click", this.outsideClickListener)
  }

  close() {
    this.menuTarget.classList.add("hidden")
    this.buttonTarget.setAttribute("aria-expanded", "false")
    document.removeEventListener("click", this.outsideClickListener)
  }

  outsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.close()
    }
  }
}