---
version: 1
slug: "app-views-rooms-show-html-erb"
primary_target: "app/views/rooms/show.html.erb"
related_targets: ["app/views/rooms/_board.html.erb","app/views/rooms/_game_info.html.erb","app/views/rooms/_me.html.erb","app/views/layouts/application.html.erb","app/assets/stylesheets/application.css"]
---

# Surface brief: game room (`/rooms/:slug`) and the shared shell

Scope: the game room is the flagship surface; the layout shell (top bar, nav) and the
other pages (welcome, rooms list, /hoje, /hall, /dias, /faq, /admin) inherit this world.
Visitor mode: Operate. Audience: developers and recruiters judging the craft, then
casual pt-BR players and spectators. Task: sit, move, read the clock, chat, predict.
Constraints: htmx partial flow stays; no JS build step; one web font at most; dark only.

## Direction contract

THESIS: The room is a tiling-window-manager workspace in the Omarchy / Tokyo Night
spirit: the board is the master pane, clocks, moves, chat and controls are stacked
panes with equal gaps and 1px borders, and the pane of the side to move carries the
active-window border. It refuses the category arrangement (charcoal ground, green
accent, rounded cards with shadows, a "hero") and any SaaS chrome.

OWN-WORLD: Tokyo Night tokens: ground #1a1b26, pane #1f2335, raised #24283b, border
#3b4261, text #c0caf5, muted #565f89, blue #7aa2f7 (focus, links, white side),
orange #ff9e64 (black side), red #f7768e (danger, clock under a minute), green #9ece6a
(success, correct guess), yellow #e0af68 (leader, crown), purple #bb9af7 (theme of the
day). JetBrains Mono only, tabular numerals everywhere, zero radius, 1px borders, 12px
gaps, no shadows, no gradients. Board squares #414868 / #2a2f45; pieces are glyphs,
white side filled #e6e9ff, black side filled #0b0d16 with a hairline light edge.

STORY: One glance says who plays, whose turn it is and how much time is left. The
active border jumps between the two clock panes when the turn changes, the digits tick,
moves and chat accumulate as a log, and a spectator's prediction is a pane of its own.

FIRST VIEWPORT: A 40px Waybar-like top bar: "chess-club" at left with the nav as
workspace tags [salas] [hoje] [hall] [faq]; at right today's points and the nickname.
Below, the workspace: the board pane fills the left 60% as a square with rank/file
coordinates in the gutter; the right column stacks the opponent's clock pane (name, side
glyph, big tabular digits), the moves pane (two-column SAN log, grows), the viewer's
clock pane, the controls pane (sit, resign, predict, close) and the chat pane (log plus
input). Primary action is always the board itself; when the viewer is a spectator, the
seat buttons in the controls pane are the primary action. On phones, everything stacks:
opponent clock, board, own clock, controls, moves, chat.

FORM: User-pinned direction (Omarchy / Tokyo Night tiling workspace), which beats the
roll. The assigned candidate 6 of the grounded list (Soviet chess bulletin) survives only
in topology: solid blocks separated by gaps, big tabular numerals, one state color owning
a whole region. Seed key 891b7d19. Signature interaction: the active-window border
moving between clock panes on turn change, 150ms color transition, the low clock blinking
red; no page-load choreography.

FINISH: unreviewed and undocumented is unfinished; this build ends with the finish review,
the verdict, DESIGN.md, and every shipping raster carrying its provenance.

## Adaptations from the contract (cited)
- `--muted` is #8a93bd, not #565f89: the contract value fails the 4.5:1 floor on the pane color.
- Right column order is opponent clock, "você" (controls), moves, own clock, chat: the
  seat and prediction buttons are the primary action for spectators and must sit above
  the fold on desktop; on phones the contract order (clock, board, clock, controls,
  moves, chat) is kept.
- Squares are #4a5378 / #2e3350 (contract #414868 / #2a2f45): the wider step keeps the
  two square colors distinguishable at phone size.
- Coordinates sit inside the corner squares instead of a gutter so the board keeps its
  full width on phones.
- Pieces are Unicode glyphs from the OS symbol font; an SVG piece set was reviewed as a
  portability improvement and deferred by the user (September 2026).

## Unresolved
- Copy stays as is except for micro-adjustments demanded by the new layout.
- PWA manifest name and theme color to be corrected to match the world.
