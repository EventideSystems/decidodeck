// import Rails from "@rails/ujs";
import { Controller } from "@hotwired/stimulus"


export default class extends Controller {

  static targets = ["select", "clear"]

  connect() {
    HSSelect.autoInit();

    this.clearTarget.addEventListener("click", this.clear.bind(this))

    let selectInstance = HSSelect.getInstance(this.selectTarget);

    let options = selectInstance.dropdown.querySelectorAll('[data-value]');

    let val = Array.from(this.selectTarget.selectedOptions).map(({value})=> value);

    options.forEach((option) => {
      let icon = option.querySelector('[data-select-icon]');

      if (icon) {
        if (icon && val.includes(option.dataset.value)) {
          icon.classList.remove('hidden');
        }
        else {
          icon.classList.add('hidden');
        }
      }
    });

    // Custom toggle text formatting
    this.updateToggleText(selectInstance, val.length);

    selectInstance.on('change', (val) => {
      let options = selectInstance.dropdown.querySelectorAll('[data-value]');
      options.forEach((option) => {
        let icon = option.querySelector('[data-select-icon]');

        if (icon) {
          if (icon && val.includes(option.dataset.value)) {
            icon.classList.remove('hidden');
          }
          else {
            icon.classList.add('hidden');
          }
        }
      });

      // Update custom toggle text on change
      this.updateToggleText(selectInstance, val.length);

      var event = new Event('change');
      this.selectTarget.dispatchEvent(event);
    });
  }

  disconnect() {
    HSSelect.getInstance(this.selectTarget).destroy()
  }

  clear() {
    let selectInstance = HSSelect.getInstance(this.selectTarget);
    let options = selectInstance.dropdown.querySelectorAll('[data-value]');
    options.forEach((option) => {
      let icon = option.querySelector('[data-select-icon]');
      icon.classList.add('hidden');
    });
    selectInstance.setValue([]);

    // Update toggle text after clearing
    this.updateToggleText(selectInstance, 0);

    var event = new Event('change');
    this.selectTarget.dispatchEvent(event);
  }

  updateToggleText(selectInstance, count) {
    const toggleButton = selectInstance.toggle;
    
    // Try multiple selectors to find the text element
    let toggleText = toggleButton.querySelector('.hs-select-option-selected-text') ||
                     toggleButton.querySelector('[data-title]') ||
                     toggleButton.querySelector('span') ||
                     toggleButton;
    
    console.log('Toggle button:', toggleButton);
    console.log('Toggle text element:', toggleText);
    console.log('Current count:', count);
    
    if (toggleText && count > 0) {
      // Get the toggleCountText from the HSSelect configuration
      const hsSelectConfig = JSON.parse(this.selectTarget.dataset.hsSelect);
      const baseText = hsSelectConfig.toggleCountText || 'selected';
      //const badgeClass = "inline-flex items-center rounded-full bg-blue-50 px-1.5 py-0.5 text-xs font-medium text-white inset-ring inset-ring-blue-700/10 dark:bg-blue-900/20 dark:text-white dark:inset-ring-blue-400/30";
      const badgeClass = "inline-flex items-center rounded-full px-1.5 py-0.5 text-xs font-medium text-white bg-blue-600 dark:bg-blue-500";
      const newText = `${baseText} <span class="${badgeClass}">${count}</span>`;

      console.log('Using toggleCountText:', baseText);
      console.log('Setting text to:', newText);
      
      // Use innerHTML to render the HTML span instead of escaping it
      toggleText.innerHTML = newText;
    }
  }

}
