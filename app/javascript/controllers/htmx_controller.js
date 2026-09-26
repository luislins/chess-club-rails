import { Controller } from "@hotwired/stimulus"

// htmx only knows about HTML it swapped itself. Nodes inserted by Turbo Streams
// (e.g. the #refresh element sent by a broadcast) must be processed by hand.
export default class extends Controller {
  connect() {
    window.htmx?.process(this.element)
  }
}
