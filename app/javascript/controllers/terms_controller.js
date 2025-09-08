import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkbox", "submit"]

  connect() {
    this.toggleSubmit()
    this.checkboxTarget.addEventListener("change", () => this.toggleSubmit())
  }

  toggleSubmit() {
    const checked = this.checkboxTarget.checked
    this.submitTarget.disabled = !checked
    if (!checked) {
      this.submitTarget.classList.add("opacity-50", "cursor-not-allowed")
    } else {
      this.submitTarget.classList.remove("opacity-50", "cursor-not-allowed")
    }
  }
}
