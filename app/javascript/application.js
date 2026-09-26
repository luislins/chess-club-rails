// Turbo is only used for Turbo Streams (WebSocket via Action Cable). Navigation and
// forms are handled by htmx, so Turbo Drive is disabled to keep them from clashing.
import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false

import htmx from "htmx.org"
window.htmx = htmx

// htmx ignores 4xx responses by default. We want 422/429 (validation errors and
// rate limiting) to be swapped, since they carry the out-of-band #flash.
htmx.config.responseHandling = [
  { code: "204", swap: false },
  { code: "[23]..", swap: true },
  { code: "42[29]", swap: true },
  { code: "[45]..", swap: false, error: true }
]

import "controllers"
