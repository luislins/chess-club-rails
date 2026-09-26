import { Controller } from "@hotwired/stimulus"

// Counts both clocks down from the numbers the server rendered. The element is
// replaced on every state refresh, so the controller always restarts from fresh
// values. When a running clock hits zero, ask the server for the state once: it
// flags the game and broadcasts to everyone.
export default class extends Controller {
  static targets = ["white", "black"]
  static values = { stateUrl: String }

  connect() {
    if (!this.hasWhiteTarget || !this.hasBlackTarget) return // room still waiting, no clocks yet
    this.startedAt = performance.now()
    this.flagged = false
    this.tick()
    this.timer = setInterval(() => this.tick(), 250)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  tick() {
    const elapsed = performance.now() - this.startedAt
    for (const el of [this.whiteTarget, this.blackTarget]) {
      let ms = Number(el.dataset.ms)
      if (el.dataset.running === "true") ms -= elapsed
      if (ms <= 0) {
        ms = 0
        if (el.dataset.running === "true") this.flag()
      }
      el.textContent = this.format(ms)
      el.classList.toggle("low", ms < 30_000 && el.dataset.running === "true")
    }
  }

  flag() {
    if (this.flagged) return
    this.flagged = true
    window.htmx?.ajax("GET", this.stateUrlValue, { target: "#board", swap: "outerHTML" })
  }

  format(ms) {
    const total = Math.ceil(ms / 1000)
    const m = Math.floor(total / 60), s = total % 60
    return `${String(m).padStart(2, "0")}:${String(s).padStart(2, "0")}`
  }
}
