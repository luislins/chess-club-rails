# Theme of the day. Most days are classic chess; Wednesdays start from the
# "opening of the day" and Saturdays get a special position.
module Arena
  class Theme
    Definition = Struct.new(:key, :name, :description, :moves, :fen, keyword_init: true) do
      def classic? = key == "classic"
    end

    CLASSIC = Definition.new(key: "classic", name: "Clássico", description: "Xadrez normal, da posição inicial.", moves: [], fen: nil)

    OPENINGS = {
      "ruy_lopez"    => [ "Ruy Lopez",           %w[e4 e5 Nf3 Nc6 Bb5] ],
      "italiana"     => [ "Abertura Italiana",   %w[e4 e5 Nf3 Nc6 Bc4] ],
      "escocesa"     => [ "Abertura Escocesa",   %w[e4 e5 Nf3 Nc6 d4] ],
      "gambito_rei"  => [ "Gambito do Rei",      %w[e4 e5 f4] ],
      "evans"        => [ "Gambito Evans",       %w[e4 e5 Nf3 Nc6 Bc4 Bc5 b4] ],
      "siciliana"    => [ "Defesa Siciliana",    %w[e4 c5] ],
      "francesa"     => [ "Defesa Francesa",     %w[e4 e6] ],
      "caro_kann"    => [ "Caro-Kann",           %w[e4 c6] ],
      "escandinava"  => [ "Defesa Escandinava",  %w[e4 d5] ],
      "pirc"         => [ "Defesa Pirc",         %w[e4 d6 d4 Nf6] ],
      "gambito_dama" => [ "Gambito da Dama",     %w[d4 d5 c4] ],
      "londres"      => [ "Sistema Londres",     %w[d4 d5 Bf4] ],
      "holandesa"    => [ "Defesa Holandesa",    %w[d4 f5] ],
      "india_rei"    => [ "Índia do Rei",        %w[d4 Nf6 c4 g6] ],
      "inglesa"      => [ "Abertura Inglesa",    %w[c4 e5] ]
    }.freeze

    SPECIALS = {
      "sem_damas" => [ "Sem damas", "As duas damas foram retiradas do tabuleiro. Vale tudo, menos rainha.",
                       "rnb1kbnr/pppppppp/8/8/8/8/PPPPPPPP/RNB1KBNR w KQkq - 0 1" ],
      "peoes"     => [ "Batalha de peões", "Só reis e peões. Quem promover primeiro leva vantagem.",
                       "4k3/pppppppp/8/8/8/8/PPPPPPPP/4K3 w - - 0 1" ]
    }.freeze

    class << self
      # Theme scheduled for a given day.
      def for(day = Arena.today)
        case day.wday
        when 3 then find("opening:#{OPENINGS.keys[day.yday % OPENINGS.size]}")
        when 6 then find("special:#{SPECIALS.keys[day.cweek % SPECIALS.size]}")
        else CLASSIC
        end
      end

      def find(key)
        kind, id = key.to_s.split(":", 2)
        case kind
        when "opening"
          name, moves = OPENINGS.fetch(id) { return CLASSIC }
          Definition.new(key: key, name: "Abertura do dia: #{name}",
                         description: "Todas as partidas de hoje começam depois de #{pgn(moves)}.", moves: moves, fen: nil)
        when "special"
          name, description, fen = SPECIALS.fetch(id) { return CLASSIC }
          Definition.new(key: key, name: "Especial: #{name}", description: description, moves: [], fen: fen)
        else
          CLASSIC
        end
      end

      def pgn(moves)
        moves.each_slice(2).with_index(1).map { |(w, b), n| "#{n}.#{w} #{b}".strip }.join(" ")
      end
    end
  end
end
