import { Controller } from "@hotwired/stimulus"

// Copies the share text to the clipboard.
export default class extends Controller {
  static targets = ["source", "button"]

  async copy() {
    const text = this.sourceTarget.value
    try {
      await navigator.clipboard.writeText(text)
    } catch {
      this.sourceTarget.select()
      document.execCommand("copy")
    }
    const label = this.buttonTarget.textContent
    this.buttonTarget.textContent = "Copiado ✓"
    setTimeout(() => { this.buttonTarget.textContent = label }, 1500)
  }
}
