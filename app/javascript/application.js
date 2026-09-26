// Turbo só para Turbo Streams (WebSocket via Action Cable). Navegação e forms ficam
// por conta do htmx, então desligamos o Turbo Drive para os dois não brigarem.
import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false

import htmx from "htmx.org"
window.htmx = htmx

// Por padrão o htmx ignora respostas 4xx. Queremos que 422/429 (erros de validação
// e rate limit) façam o swap, pois trazem o #flash out-of-band.
htmx.config.responseHandling = [
  { code: "204", swap: false },
  { code: "[23]..", swap: true },
  { code: "42[29]", swap: true },
  { code: "[45]..", swap: false, error: true }
]

import "controllers"
