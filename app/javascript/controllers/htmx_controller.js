import { Controller } from "@hotwired/stimulus"

// O htmx só "conhece" o HTML que ele mesmo trocou. Nós inseridos pelo Turbo Streams
// (ex: o #refresh enviado pelo broadcast) precisam ser processados manualmente.
export default class extends Controller {
  connect() {
    window.htmx?.process(this.element)
  }
}
