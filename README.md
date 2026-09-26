# ♞ Chess Club

A small hobby project: online chess rooms. Each room has one board, two players,
any number of spectators and a chat, all updated in real time. No sign-up, no login.

## Stack

- **Rails 8.1** with the Solid trifecta in production: Solid Cache (rate limiting),
  Solid Queue (room cleanup) and Solid Cable (WebSockets), all backed by SQLite.
- **htmx** for every interaction (selecting a piece, moving, taking a seat, chat,
  polling the room list).
- **Hotwire Turbo Streams** only for server push over Action Cable. Turbo Drive is
  disabled so it doesn't fight with htmx.
- **Stimulus** for two small things: calling `htmx.process()` on HTML inserted by
  Turbo, and keeping the chat scrolled to the bottom.
- **Pico CSS** (vendored in `app/assets/stylesheets/pico.min.css`). No Tailwind.
- The **[chess](https://github.com/pioz/chess)** gem enforces the rules on the server
  (legal moves, castling, promotion, checkmate, draws).

## How real time works

1. Every action (`POST /rooms/:slug/moves`, `seat`, `resignation`) responds to the
   caller with the `rooms/_state` partial: the board plus htmx out-of-band panels.
2. The server then calls `room.broadcast_refresh`, which pushes a `<div id="refresh">`
   with `hx-get=".../state" hx-trigger="load"` through Turbo Streams.
3. The `htmx` Stimulus controller runs `htmx.process()` on that node, htmx issues the
   GET, and every client receives **its own** view of the room (board flipped for
   black, squares only clickable on your turn, and so on).
4. Chat messages use `broadcast_append_to room` directly from the model.

## Identity and limits (without accounts)

- Each browser gets a random `player_token` in the session. Nicknames are optional.
- Global limits live in `app/models/room.rb`: at most `MAX_OPEN_ROOMS` open rooms,
  one open room per creator, `MAX_MESSAGES` chat messages per room. Rooms idle for
  `STALE_AFTER` (or finished more than `FINISHED_TTL` ago) are removed by
  `RoomCleanupJob`, scheduled with Solid Queue (`config/recurring.yml`) and also
  available from the admin area.
- Rate limiting uses the built-in Rails `rate_limit` (per IP) on room creation,
  seats, moves, chat, nicknames and the admin area. 429 responses land in `#flash`
  through an htmx out-of-band swap.

## Admin

`/admin` is protected with HTTP Basic auth. Set `ADMIN_USER` (defaults to `admin`) and
`ADMIN_PASSWORD` (defaults to `admin` in development/test; **required in production**,
otherwise the area is locked). It lists rooms, clears chats, closes rooms and removes
stale ones.

## Running

```sh
bundle install
bin/rails db:prepare
bin/dev            # http://localhost:3000
bin/rails test
```

In development Action Cable uses the in-process `async` adapter and the cache is
in-memory, so real time and rate limiting work out of the box. In production also run
`bin/jobs` (Solid Queue) so rooms get cleaned up automatically.
