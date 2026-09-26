import { Controller } from "@hotwired/stimulus"

// Rola o chat para o fim sempre que uma mensagem nova é anexada (via Turbo Stream).
export default class extends Controller {
  static targets = ["message"]

  connect() {
    this.scrollToBottom()
  }

  messageTargetConnected() {
    this.scrollToBottom()
  }

  scrollToBottom() {
    this.element.scrollTop = this.element.scrollHeight
  }
}
