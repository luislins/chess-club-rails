# ♞ Chess Club

Um clubinho de xadrez online, de hobby: salas com um tabuleiro cada, dois jogadores,
espectadores e chat, tudo em tempo real. Sem cadastro nem login.

## Stack

- **Rails 8.1** com a *Solid trifecta* em produção: Solid Cache (rate limit), Solid Queue
  (limpeza de salas) e Solid Cable (WebSocket) — tudo em SQLite.
- **htmx** para toda a interação (clicar peça, mover, sentar, chat, polling da lista de salas).
- **Hotwire Turbo Streams** só para o *push* via Action Cable. O Turbo Drive está desligado
  para não brigar com o htmx.
- **Stimulus** para dois detalhes: chamar `htmx.process()` em HTML inserido pelo Turbo e
  rolar o chat pro fim.
- **Pico CSS** (vendorizado em `app/assets/stylesheets/pico.min.css`, sem Tailwind).
- Gem **[chess](https://github.com/pioz/chess)** valida as regras no servidor
  (lances legais, roque, promoção, mate, empates).

## Como funciona o tempo real

1. Toda ação (`POST /rooms/:slug/moves`, `seat`, `resignation`) responde ao próprio
   cliente com o partial `rooms/_state` (tabuleiro + painéis out-of-band do htmx).
2. O servidor faz `room.broadcast_refresh`, que envia por Turbo Stream um `<div id="refresh">`
   com `hx-get=".../state" hx-trigger="load"`.
3. O Stimulus (`htmx_controller`) chama `htmx.process()` nesse nó, o htmx faz o GET e cada
   cliente recebe **o seu** estado (tabuleiro invertido para as pretas, casas clicáveis só
   na sua vez, etc.).
4. Chat: `Message` faz `broadcast_append_to room` direto.

## Identidade e limites (sem login)

- Cada navegador ganha um `player_token` aleatório na sessão. Apelido é opcional (canto superior).
- Limites globais em `app/models/room.rb`: no máximo `MAX_OPEN_ROOMS` salas abertas, uma sala
  aberta por criador, chat com `MAX_MESSAGES` mensagens por sala. Salas paradas por
  `STALE_AFTER` (ou terminadas há `FINISHED_TTL`) são removidas pelo `RoomCleanupJob`
  (recorrente no Solid Queue, ver `config/recurring.yml`) ou pelo admin.
- Rate limit (`rate_limit` nativo do Rails, por IP): criar sala, sentar, mover, chat,
  apelido e a área admin. Respostas 429 caem no `#flash` via htmx.

## Admin

`/admin` com HTTP Basic. Variáveis `ADMIN_USER` (padrão `admin`) e `ADMIN_PASSWORD`
(padrão `admin` em dev/test; **obrigatória em produção**, senão o acesso fica bloqueado).
Lista salas, limpa chat, fecha salas e remove salas antigas.

## Rodando

```sh
bundle install
bin/rails db:prepare
bin/dev            # http://localhost:3000
bin/rails test
```

Em desenvolvimento o Action Cable usa o adapter `async` (mesmo processo) e o cache é em
memória, então o rate limit e o tempo real funcionam sem nada extra. Em produção rode
também `bin/jobs` (Solid Queue) para a limpeza automática das salas.
