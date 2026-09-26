import { Controller } from "@hotwired/stimulus"

// Scrolls the chat to the bottom whenever a new message is appended (via Turbo Stream).
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
