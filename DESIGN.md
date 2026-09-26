---
name: Chess Club
description: A daily chess arena laid out as a Tokyo Night tiling-window-manager workspace; flat panes, hairline borders, one mono face.
colors:
  night-ground: "#1a1b26"
  bar-deep: "#16161e"
  pane: "#1f2335"
  raised: "#24283b"
  hover: "#292e42"
  hairline: "#3b4261"
  hairline-hi: "#545c7e"
  text: "#c0caf5"
  text-soft: "#9aa5ce"
  muted: "#8a93bd"
  blue: "#7aa2f7"
  blue-hover: "#8fb3ff"
  cyan: "#7dcfff"
  orange: "#ff9e64"
  red: "#f7768e"
  green: "#9ece6a"
  yellow: "#e0af68"
  purple: "#bb9af7"
  sq-light: "#4a5378"
  sq-dark: "#2e3350"
  piece-white: "#e8ecff"
  piece-black: "#10111a"
  selection: "#33467c"
typography:
  display:
    fontFamily: "JetBrains Mono, ui-monospace, SFMono-Regular, Menlo, Consolas, monospace"
    fontSize: "1.75rem"
    fontWeight: 800
    lineHeight: 1.5
    letterSpacing: "-0.02em"
  clock:
    fontFamily: "JetBrains Mono, ui-monospace, SFMono-Regular, Menlo, Consolas, monospace"
    fontSize: "2.75rem"
    fontWeight: 700
    lineHeight: 1
    letterSpacing: "-0.02em"
  headline:
    fontFamily: "JetBrains Mono, ui-monospace, SFMono-Regular, Menlo, Consolas, monospace"
    fontSize: "1.25rem"
    fontWeight: 700
    lineHeight: 1.5
    letterSpacing: "-0.01em"
  title:
    fontFamily: "JetBrains Mono, ui-monospace, SFMono-Regular, Menlo, Consolas, monospace"
    fontSize: "1rem"
    fontWeight: 700
    lineHeight: 1.5
  subtitle:
    fontFamily: "JetBrains Mono, ui-monospace, SFMono-Regular, Menlo, Consolas, monospace"
    fontSize: "0.875rem"
    fontWeight: 700
    lineHeight: 1.5
  body:
    fontFamily: "JetBrains Mono, ui-monospace, SFMono-Regular, Menlo, Consolas, monospace"
    fontSize: "0.8125rem"
    fontWeight: 400
    lineHeight: 1.5
  label:
    fontFamily: "JetBrains Mono, ui-monospace, SFMono-Regular, Menlo, Consolas, monospace"
    fontSize: "0.75rem"
    fontWeight: 700
    lineHeight: 1.5
    letterSpacing: "0.02em"
  meta:
    fontFamily: "JetBrains Mono, ui-monospace, SFMono-Regular, Menlo, Consolas, monospace"
    fontSize: "0.75rem"
    fontWeight: 400
    lineHeight: 1.5
rounded:
  none: "0"
  dot: "50%"
spacing:
  2xs: "2px"
  xs: "4px"
  sm: "8px"
  md: "12px"
  lg: "16px"
  xl: "20px"
components:
  button-default:
    backgroundColor: "{colors.raised}"
    textColor: "{colors.text}"
    typography: "{typography.body}"
    rounded: "{rounded.none}"
    padding: "0 12px"
    height: "32px"
  button-default-hover:
    backgroundColor: "{colors.hover}"
  button-default-active:
    backgroundColor: "{colors.hairline}"
  button-primary:
    backgroundColor: "{colors.blue}"
    textColor: "{colors.night-ground}"
    typography: "{typography.body}"
    rounded: "{rounded.none}"
    padding: "0 12px"
    height: "32px"
  button-primary-hover:
    backgroundColor: "{colors.blue-hover}"
  button-outline:
    backgroundColor: "transparent"
    textColor: "{colors.text}"
    rounded: "{rounded.none}"
    padding: "0 12px"
    height: "32px"
  button-danger:
    backgroundColor: "transparent"
    textColor: "{colors.red}"
    rounded: "{rounded.none}"
    padding: "0 12px"
    height: "32px"
  button-ghost:
    backgroundColor: "transparent"
    textColor: "{colors.text-soft}"
    rounded: "{rounded.none}"
    padding: "0 12px"
    height: "32px"
  button-small:
    typography: "{typography.meta}"
    padding: "0 8px"
    height: "26px"
  button-on:
    textColor: "{colors.cyan}"
  input-text:
    backgroundColor: "{colors.bar-deep}"
    textColor: "{colors.text}"
    typography: "{typography.body}"
    rounded: "{rounded.none}"
    padding: "4px 8px"
    height: "32px"
  bar:
    backgroundColor: "{colors.bar-deep}"
    typography: "{typography.body}"
    padding: "0 12px"
    height: "40px"
  bar-tag:
    textColor: "{colors.text-soft}"
    padding: "0 10px"
  bar-tag-hover:
    backgroundColor: "{colors.raised}"
    textColor: "{colors.text}"
  bar-tag-current:
    backgroundColor: "{colors.raised}"
    textColor: "{colors.text}"
  pane:
    backgroundColor: "{colors.pane}"
    textColor: "{colors.text}"
    rounded: "{rounded.none}"
    padding: "12px"
  pane-head:
    textColor: "{colors.muted}"
    typography: "{typography.label}"
    padding: "6px 12px"
    height: "30px"
  tag:
    typography: "{typography.label}"
    rounded: "{rounded.none}"
    padding: "0 6px"
    height: "20px"
  clock-digits:
    textColor: "{colors.text-soft}"
    typography: "{typography.clock}"
  clock-digits-active:
    textColor: "{colors.text}"
  clock-digits-low:
    textColor: "{colors.red}"
  square-light:
    backgroundColor: "{colors.sq-light}"
  square-dark:
    backgroundColor: "{colors.sq-dark}"
  square-hover:
    backgroundColor: "{colors.hover}"
  table-head:
    textColor: "{colors.muted}"
    typography: "{typography.label}"
    padding: "8px 12px"
  table-cell:
    typography: "{typography.body}"
    padding: "8px 12px"
  table-row-hover:
    backgroundColor: "{colors.raised}"
---

# Design System: Chess Club

## Overview

**Creative North Star: "Noite de Tóquio no Clube"**

The whole product is one tiling-window-manager workspace in the Omarchy / Tokyo Night spirit. A 40px bar sits on top like a Waybar, the pages below are panes separated by equal 12px gaps and 1px hairlines, and in the game room the board is the master pane while clocks, moves, controls and chat stack beside it. Everything is set in JetBrains Mono with tabular numerals, so digits line up in the clock, the move log and the ranking the way they do in a terminal. Nothing is rounded, nothing casts a shadow, nothing is gradient. The only emphasis the system allows itself is a border that changes color: the pane of the side to move carries the "active window" border, blue for white, orange for black, and it jumps between the two clock panes when the turn changes.

The mood is calm, dense and technical, but not cold. The warmth of a hobby club comes through the copy (short, informal Brazilian Portuguese: "diga só como quer ser chamado hoje", "Torça!"), through the knight glyph next to the name, and through the small living details (ticking digits, a move log that grows, a crowd bar that fills as spectators guess), never through decoration. Density is a feature: a room shows who plays, whose turn it is, how much time is left, the moves and the chat in one viewport, on desktop and on a phone.

Confirmed rejections: corporate SaaS chrome (cards with drop shadows, gradients, a hero section), the Lichess / Chess.com arrangement (charcoal ground with a green accent), and heavy pages. The build is one hand-written stylesheet, one web font, dark only.

**Key Characteristics:**
- Tiling-workspace topology: panes with 1px borders and equal 12px gaps; the board is the master pane.
- Tokyo Night palette on a blue-night ground; two side colors (blue for white, orange for black) plus five state colors used sparingly.
- JetBrains Mono everywhere, tabular numerals everywhere; lowercase labels.
- Zero radius, no shadows, no gradients; depth is a hairline and the active-window border.
- Motion limited to a 150ms color transition and the low clock blinking red; no page-load choreography.

## Colors

A dark blue-night ground with lavender text and a small set of saturated Tokyo Night accents, each owning one meaning.

### Primary
- **Night Blue** (`blue`, #7aa2f7): the one action color. Links, focus rings, the caret, the primary button fill, the brand name in the bar, the active nav underline, and the white side (active clock border, "Você joga de Brancas", the white half of the crowd bar). Its hover step is **Night Blue Light** (`blue-hover`, #8fb3ff), used only on the primary button.

### Secondary
- **Ember Orange** (`orange`, #ff9e64): the black side. Active clock border and side label when black is to move, "Você joga de Pretas", the black half of the crowd bar, and the win streak marker in the ranking. It never appears as a generic accent.

### Tertiary
- **Rose Red** (`red`, #f7768e): danger and alarm. Resign button text and hover border, error flash, invalid input border, the clock under a minute.
- **Moss Green** (`green`, #9ece6a): success. Notice flash, "saved" nickname confirmation.
- **Amber Yellow** (`yellow`, #e0af68): the leader and selection. Today's points in the bar, the viewer's own row in the ranking (yellow name on an 8% amber wash), the finished-game status, the selected square's inset ring, the promotion picker border.
- **Lilac Purple** (`purple`, #bb9af7): the theme of the day, as a chip, and nothing else.
- **Sky Cyan** (`cyan`, #7dcfff): the "chosen" state. Legal-move target dots and capture rings, the `on` button (the prediction you already made), chat author names.

### Neutral
- **Night Ground** (`night-ground`, #1a1b26): the page background.
- **Bar Deep** (`bar-deep`, #16161e): the top bar and the inside of text inputs, one step below the ground so fields read as wells.
- **Pane** (`pane`, #1f2335): every pane and flash surface.
- **Raised** (`raised`, #24283b): default button fill, hovered nav tag, hovered table row, hovered move, promotion picker.
- **Hover** (`hover`, #292e42): hovered button and hovered board square.
- **Hairline** (`hairline`, #3b4261): every 1px border, table rule, move-log rule, scrollbar thumb, the crowd bar track, the pressed button fill.
- **Hairline High** (`hairline-hi`, #545c7e): hovered borders on buttons and inputs.
- **Lavender Text** (`text`, #c0caf5): body text, names, the active clock digits.
- **Soft Lavender** (`text-soft`, #9aa5ce): secondary text, nav tags at rest, pane-head titles, idle clock digits, board coordinates.
- **Muted Lavender** (`muted`, #8a93bd): pane-head values, table headers, placeholders, empty states, move numbers. Lifted from Tokyo Night's #565f89 because that value fails 4.5:1 on the pane color.
- **Square Light / Square Dark** (`sq-light` #4a5378, `sq-dark` #2e3350): the board, two steps of the same hue so it reads as part of the pane.
- **Piece White / Piece Black** (`piece-white` #e8ecff, `piece-black` #10111a): filled piece glyphs; the black piece carries a hairline light edge so it stays visible on the dark squares.
- **Selection** (`selection`, #33467c): text selection only.

### Named Rules
**The Two Sides Rule.** Blue is white and orange is black, everywhere a side is named: clock borders, side labels, "Você joga de", the crowd bar. No other element borrows a side color, and the sides never swap hues.

**The One Region Rule.** A state color owns a whole region or nothing: the active clock pane's border and label, the entire low clock, the whole resign button. Do not sprinkle an accent across unrelated text.

**The Current-Color Chip Rule.** Chips, tags and flashes are outlined in `currentColor` on the pane surface; the text color is the only thing that changes between variants.

## Typography

**Display Font:** JetBrains Mono (with ui-monospace, SFMono-Regular, Menlo, Consolas, monospace)
**Body Font:** JetBrains Mono (same stack)
**Label/Mono Font:** JetBrains Mono (same stack)

**Character:** One monospaced face carries every role, from the 44px clock to the 12px pane-head label, with `font-variant-numeric: tabular-nums` set on the body and on every control so times, points and move numbers stay in columns. Weight and size do all the work; there is no italic, no second family, no uppercase transform outside the FAQ group headers.

### Hierarchy
- **Display** (800, 1.75rem / 28px, line-height 1.5, -0.02em): the "chess-club" wordmark on the welcome pane only.
- **Clock** (700, 2.75rem / 44px, line-height 1, -0.02em; 2rem at 860px and below): the remaining time in a clock pane. Idle clocks (no game yet) drop to the title size at weight 400 in muted.
- **Headline** (700, 1.25rem / 20px, -0.01em): page-level `h1`. In the game room the `h1` is the room name inside the board pane's head and shrinks to the subtitle size.
- **Title** (700, 1rem / 16px): `h2`, and the idle clock text.
- **Subtitle** (700, 0.875rem / 14px): `h3`, the room name in the board pane head.
- **Body** (400, 0.8125rem / 13px, line-height 1.5): all reading text, buttons, inputs, table cells, chat, the move log. The welcome pane caps reading width at 34rem.
- **Label** (700, 0.75rem / 12px, 0.02em, lowercase): pane-head titles, table headers, chips, the promotion prompt. The FAQ group header is the single uppercase register (0.04em, muted).
- **Meta** (400, 0.75rem / 12px): `small`, pane-head values (counts, dates), side labels, the crowd row, stats, nickname label.

### Named Rules
**The One Face Rule.** JetBrains Mono is the only web font and the only family. A new surface never introduces a second face, a serif, or a system display face.

**The Tabular Rule.** Every number is tabular. Clocks, points, move numbers and counts must not shift width as they change.

**The Lowercase Label Rule.** Nav tags, pane titles, table headers, chip text and button text are lowercase words ("salas", "lances", "criar sala"), like window titles in a tiling workspace. Sentence case is for prose only.

## Layout

The page is a workspace: a sticky 40px bar (`--bar-h`) across the top, then a `main` of at most 1440px padded by 12px, with panes separated by a single 12px gap (`--gap`). Pane padding is the same 12px (`--pad`), so the rhythm inside a pane equals the rhythm between panes. Smaller steps are 2px (nav tag gaps, chat lines), 4px, 6px (pane-head vertical padding), 8px (form rows, control gaps) and 10px (nav tag horizontal padding, FAQ rows); 16px and 20px appear only in key-value grids, stats rows and the FAQ header.

Composition helpers are a vertical `stack` (grid, 12px gap), a `cols-2` that collapses under 760px, and an `arena-row` on the rooms index that collapses under 860px. Narrow reading pages (`main.narrow`) cap at 760px; the welcome pane caps at 34rem and floats 6vh from the top.

The game room is a two-column grid: the board pane takes `minmax(0, auto)` on the left and sizes itself to `min(100%, 100dvh − bar − 92px)` so the whole board fits the viewport; the right column is `minmax(300px, 360px)` and stacks, top to bottom, the opponent's clock, the "você" controls pane, the moves pane (stretches to fill), the viewer's clock, and chat. Seat and prediction buttons sit above the fold on desktop because they are a spectator's primary action. At 860px and below the room becomes one column in the order opponent clock, board, own clock, controls, moves, chat; the board's time-control text hides, the moves pane caps at 40vh and scrolls, and the clock drops to 2rem.

Breakpoints, all `max-width`: 860px (room and arena stack, tables tighten to 12px type and 6px/8px cells), 760px (`cols-2` stacks), 700px (bar compresses: brand text and separator hide, nav padding 8px), 520px (nickname form leaves the bar, the new-room field wraps, stats wrap in pane heads). The bar's nav list scrolls horizontally rather than wrapping.

### Named Rules
**The Equal Gap Rule.** Panes are separated by 12px and padded by 12px. No pane has a margin of its own; spacing belongs to the grid.

**The Board Is the Master Rule.** The board pane is sized from the viewport height so it never scrolls; everything else adapts around it.

## Elevation & Depth

Flat, with tonal layering and no shadows. Surfaces step by tone: bar (`bar-deep`) below the ground (`night-ground`), pane above it, `raised` for controls and hovered rows, `hover` for the hovered control. Every edge is a 1px `hairline`, brightened to `hairline-hi` on hover. Depth as such is carried by exactly one device: the active-window border, where the clock pane of the side to move switches its border and adds a 1px inset ring of the side color (blue or orange), with a 150ms color transition, so the border appears 2px thick without any shadow.

`box-shadow` is used only as an inset stroke, never as elevation: the active pane's 1px ring, the selected square's 3px amber ring, the capture target's 3px cyan ring, and the current nav tag's 2px blue underline. `text-shadow` appears only as a 1px hairline edge on piece glyphs so the black piece stays visible on the dark square.

### Named Rules
**The Hairline Rule.** Depth is a 1px `hairline` border or nothing. No drop shadow, no blur, no gradient, no translucent glass.

**The Active Window Rule.** Emphasis is a border that changes color. The one region that needs attention (the side to move) gets the side color on its border and label; nothing else lights up.

## Shapes

Square everywhere. Radius is 0 on buttons, inputs, panes, chips, flashes, the board and the squares; the scrollbar thumb is a plain bar. The single curve in the system is the legal-move target, a dot at 28% of the square with `border-radius: 50%` in cyan at 55% opacity; a capture target replaces it with a square 3px inset ring. Borders are 1px and always present on controls, so a button and an input placed side by side in a `.field` overlap by 1px (`margin-left: -1px`) and read as one segmented control. Panes are sections with a `pane-head` strip (30px, hairline below) and one or more `pane-body` blocks separated by hairlines. The board is a bordered 8x8 grid with rank numbers in the top-left of the a-file squares and file letters in the bottom-right of the first rank, drawn inside the squares rather than in a gutter.

## Components

The controls are square, quiet and keyboard-honest: every interactive element has a 1px border, a 32px minimum height, a hover that brightens the border and fill, and a 2px blue `focus-visible` outline; nothing moves or scales.

### Buttons
- **Shape:** square (radius 0), 1px border, 32px min height, `0 12px` padding, inline-flex with a `.5ch` gap for the glyph.
- **Default:** `raised` fill, `hairline` border, `text` label. Hover: `hover` fill, `hairline-hi` border. Active: `hairline` fill. Disabled: 50% opacity.
- **Primary:** `blue` fill and border, `night-ground` label, weight 700 ("entrar na arena", "criar sala", "♙ sentar como Brancas"). Hover: `blue-hover`.
- **Outline:** transparent fill, `hairline` border ("levantar", the unmade prediction, "assistir").
- **Danger:** outline with `red` text; hover turns the border red and washes the fill with 8% red ("desistir").
- **Ghost:** no fill, no border, `text-soft` label; hover fills `hover` and lifts to `text` ("fechar sala").
- **Small:** 26px min height, `0 8px`, meta size (table actions, "fechar sala").
- **On:** `cyan` text and border, marks the choice already made (your prediction).
- **Transitions:** border, background and color over `150ms cubic-bezier(.2, .7, .2, 1)`; nothing else animates.

### Chips
- **Style:** inline block, 20px line, `0 6px`, label typography, 1px `currentColor` border on the pane surface, no fill.
- **Variants:** `purple` (theme of the day), `green`, `red`, `blue`, `yellow`, `muted`; the color is the text color and the border follows.
- **Flash:** the same outline treatment at pane width, `8px 12px`, `red` for errors and `green` for notices.

### Cards / Containers
- **Pane:** `pane` fill, 1px `hairline` border, radius 0, no shadow, `min-width: 0` so it can shrink in the grid.
- **Pane head:** 30px strip, `6px 12px`, hairline below, muted meta text with a bold `text-soft` lowercase title at left and a value (count, date, link) at right.
- **Pane body:** 12px padding; consecutive bodies are separated by a hairline. Tables and the move log sit in a body with no padding so their rules run edge to edge.
- **Active:** border and 1px inset ring in `--active` (the side color), head rule included.

### Inputs / Fields
- **Style:** `bar-deep` well, 1px `hairline` border, radius 0, 32px min height, `4px 8px`, `muted` placeholder. Select uses the same well with an inline chevron and no native appearance.
- **Hover / Focus:** border to `hairline-hi` on hover; on focus the outline is dropped and the border turns `blue`.
- **Invalid:** border `red` via `aria-invalid="true"`.
- **Field group:** input, select and submit sit flush in a row with a 1px overlap; the input grows, the controls keep their width. Under 520px the new-room submit wraps to a full-width row.

### Navigation
- **Bar:** sticky, 40px, `bar-deep` with a hairline below, `0 12px`. Left: the brand ("♞ chess-club" in `blue` 700, knight in `text`) then the workspace tags "salas", "hoje", "hall", "faq". Right: today's points (`yellow` number), a 1px separator, the nickname form.
- **Tags:** full-height links, `0 10px`, `text-soft`, lowercase. Hover: `raised` fill, `text`. Current page: `raised` fill, `text`, and a 2px `blue` inset underline. No underline on hover in the bar.
- **Mobile:** under 700px the brand text and separator hide (the knight stays), tag padding drops to 8px, the nickname input narrows to 6.5rem; under 520px the nickname form leaves the bar. The tag list scrolls horizontally, never wraps.

### Tables
- **Style:** full width, collapsed borders, hairline under every row, `8px 12px` cells, lowercase muted label headers, `.num`/`.right` cells right-aligned. Row hover fills `raised`. The viewer's own row (`tr.me`) gets an 8% amber wash and a bold `yellow` name.

### Clock Pane (signature)
A pane with a single body: on the left the side label ("♙ Brancas", plus " · a jogar" when it is their turn) in meta over the player name in bold, or "cadeira vazia" in muted 400; on the right the remaining time in the clock role, `text-soft` at rest. When that side is to move the pane goes `active`: border and inset ring in the side color, side label in the side color, digits in `text`. Under a minute the digits turn `red` and blink at 1s in two steps. Before the game starts the clock slot shows the time control ("10 min") at title size, weight 400, muted. The pane's `--active` is set by `data-side` (`white-side` = blue, `black-side` = orange), so the same markup carries both sides.

### Board (signature)
An 8x8 grid, 1px hairline border, `aspect-ratio: 1`, container-sized type (`9cqw` pieces, `max(10px, 2.2cqw)` coordinates). Light squares `sq-light`, dark `sq-dark`; hoverable squares (your own pieces, legal targets) are buttons that fill `hover` on hover and take the focus ring 2px inside. Selected: 3px inset `yellow` ring. Legal target: cyan dot at 28%, 55% opacity, 100% on hover. Capture: 3px inset `cyan` ring at 90%. The board rotates 180° for black and rotates each square back so glyphs stay upright. While an htmx request is in flight the board dims to 75%. A promotion picker appears above it as a `raised` strip with an amber border and four glyph buttons.

## Do's and Don'ts

### Do:
- **Do** build every new surface as panes: `pane` fill, 1px `hairline` border, a 30px `pane-head` with a lowercase title at left and a value at right, 12px gaps between panes and 12px padding inside (The Equal Gap Rule).
- **Do** keep radius at 0 and depth at a hairline; when something needs emphasis, change its border color, as the active clock pane does (The Active Window Rule).
- **Do** set every number in tabular figures and keep clocks, points and counts in JetBrains Mono (The Tabular Rule).
- **Do** use `blue` for white and `orange` for black wherever a side is named, and only there (The Two Sides Rule).
- **Do** give every interactive element the 1px border, the 32px min height, the `hairline-hi` hover and the 2px `blue` focus-visible outline; a `.field` row overlaps borders by 1px.
- **Do** write labels, nav tags, pane titles and button text as lowercase Portuguese words ("nova sala", "lances", "enviar").
- **Do** limit motion to the 150ms color transition and the low-clock blink, and honor `prefers-reduced-motion` by turning both off.

### Don't:
- **Don't** add drop shadows, gradients, blur, glass or rounded corners; the confirmed rejection is SaaS card chrome and a hero section.
- **Don't** use a charcoal ground with a green accent or otherwise drift toward the Lichess / Chess.com arrangement; the ground is blue-night and green means success only.
- **Don't** introduce a second typeface, an italic, or a system display face; JetBrains Mono at 400, 700 and 800 is the whole ramp (The One Face Rule).
- **Don't** let a side color or a state color appear as decoration on unrelated text; a color owns a region or stays out (The One Region Rule).
- **Don't** give a pane its own margin or a one-off padding; spacing belongs to the 12px grid.
- **Don't** add page-load choreography, staggered reveals or hover transforms; the workspace is still until the state changes.
- **Don't** darken `muted` back to Tokyo Night's #565f89; the build lifted it to #8a93bd to clear 4.5:1 on the pane surface.
