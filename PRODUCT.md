# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

- **Primary: developers and recruiters evaluating the project.** They arrive from the
  GitHub README or a shared link, open the app for a few minutes, click around one or
  two rooms, maybe play a few moves against themselves in two tabs, and judge the
  craft. They rarely come back. Their job: decide in minutes whether the author ships
  polished, thoughtful software.
- **Secondary: casual players and spectators.** People who join a room to play a quick
  timed game or to watch and guess the winner. Portuguese speakers (pt-BR). They must
  be able to use the product for real, because the evaluators are judging exactly that.
- Desktop and phone usage are expected in equal measure. Neither is secondary.

## Product Purpose

Chess Club is a hobby project: online chess rooms with one board, two players, any
number of spectators and a chat, updated in real time, with no sign-up or login. On
top of the rooms sits a **daily arena**: everything resets at midnight (Brasília), a
ranking accumulates during the day, and only the day's champion survives into a hall
of fame.

Success for the primary user is a fast, convincing impression of quality: the app
loads, feels alive (moves appear in real time, clocks tick), reads as intentional, and
the code behind it is small and legible. Success for the secondary user is finishing
a game without friction.

## Positioning

- **A club that restarts every day.** Nicknames, points, streaks and predictions all
  belong to a single day. There are no accounts, no ratings history, no pressure. The
  hall of fame is the only durable thing.
- **Spectators are participants.** Anyone watching can predict the winner until move
  10 and earn points in the same ranking as the players.
- **Server-driven real time with almost no JavaScript.** Rules, clocks and scoring live
  on the server (Rails + the `chess` gem); the browser is htmx plus three tiny
  Stimulus controllers. This is a deliberate architectural stance and part of what
  the project demonstrates.

## Operating Context

- Language: Brazilian Portuguese throughout the UI. Chess notation is standard SAN.
- Time zone: Brasília. The day rollover at midnight and the theme of the day depend
  on it.
- Rooms are ephemeral: at most a fixed number of open rooms, one open room per
  creator, idle rooms removed by a job.
- A game has a clock per side (3 to 15 minutes, no increment).
- Theme of the day: classic chess most days; Wednesdays start from an "opening of the
  day"; Saturdays use a special position (no queens, or kings and pawns only).
- The day recap (`/dias/:data`) produces plain text ready to paste in WhatsApp.
- Pages: welcome (first visit, choose a name for today), rooms list (`/`), room (board,
  clocks, moves, chat, seat and prediction controls), today's ranking (`/hoje`), hall
  of fame (`/hall`), day recap (`/dias/:data`), FAQ (`/faq`), admin (`/admin`, HTTP
  Basic).

## Capabilities and Constraints

- Stack: Rails 8.1, SQLite, Solid Cache/Queue/Cable, htmx for interaction, Turbo
  Streams only for server push, Stimulus for small details, importmap + Propshaft
  (no JS/CSS build step). One hand-written stylesheet; JetBrains Mono is the only web
  font, loaded from Google Fonts.
- **The user placed no constraint on the frontend stack or the identity for the
  redesign** (September 2026). The name and knight glyph are not binding. Changes
  should keep the codebase small and legible, since that is part of what is being
  demonstrated.
- Server validates every move; the UI never needs to know chess rules.
- Real-time updates arrive as a "refresh" signal; each client then fetches its own
  view of the room (board flipped for black, controls only on your turn).
- Rate limiting per IP on room creation, seats, moves, chat, nicknames and admin;
  429 responses are shown in the flash area.
- Chess960 is out of scope (the rules gem does not implement 960 castling).

## Brand Commitments

- Name in use: "Chess Club", written as `chess-club` with a knight glyph (♞) in the
  top bar and welcome page. Not binding per the user; treat as incumbent, not sacred.
- Visual direction pinned by the user (September 2026): the Omarchy / Tokyo Night
  spirit (dark blue-night ground, JetBrains Mono, square corners, tiling-window-manager
  panes), no period effects, dark only. Recorded in DESIGN.md.
- Voice in use: short, warm, informal Brazilian Portuguese ("Diga só como quer ser
  chamado hoje", "Torça!"). Emoji are used as icons for arena concepts: 👑 leader,
  🏆 champion, 🔮 best predictor, ⚡ fastest mate, 🔥 streak.

## Evidence on Hand

- Real content: all UI copy, FAQ, scoring rules (`app/models/arena.rb`), theme list
  (`app/models/arena/theme.rb`).
- Assets: `public/icon.svg`, `public/icon.png` (a 4x4 checkerboard in the palette,
  drawn in September 2026; the PWA manifest carries the name "Chess Club").
- No screenshots, logo, testimonials, usage numbers or press exist. The README with
  screenshots is planned after the redesign. Do not fabricate player counts, quotes
  or "trusted by" claims.

## Product Principles

1. **Craft is the pitch.** Every screen is being judged as a work sample. Details
   (alignment, states, motion, copy) matter more than feature count.
2. **Alive by default.** The product's core promise is real time. Boards, clocks and
   rankings should visibly move; stale-looking screens undermine the whole point.
3. **Playable without reading.** No sign-up and no manual: a stranger on a phone must
   be able to sit down and move a piece in seconds.
4. **The day is the unit.** Reinforce the midnight reset, today's theme and today's
   leader everywhere; the arena is what distinguishes this from a bare chess board.
5. **Small surface, honest code.** Prefer solutions that keep the codebase readable
   over ones that add tooling or abstraction.

## Accessibility & Inclusion

No formal standard was set. Baseline expectations: the board must be usable on touch
and mouse, pieces must remain distinguishable for people with reduced color vision
(shape, not only color), and clocks and status must be readable at phone sizes.
