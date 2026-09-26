# A room is a single board: two players (session tokens) plus any number of spectators.
# The game state is the list of moves (SAN); the board is rebuilt with the `chess` gem,
# which enforces the rules (legal moves, checkmate, stalemate, draws...).
class Room < ApplicationRecord
  class Error < StandardError; end
  class PromotionNeeded < Error
    attr_reader :from, :to
    def initialize(from, to) = (@from, @to = from, to; super("promotion needed"))
  end

  MAX_OPEN_ROOMS = 20        # global cap on open rooms (no login, so keep abuse in check)
  STALE_AFTER    = 2.hours   # rooms with no activity get removed
  FINISHED_TTL   = 1.hour    # finished rooms stay visible for a while
  MAX_MESSAGES   = 200       # chat history kept per room

  COLORS = %w[white black].freeze

  has_many :messages, dependent: :delete_all

  serialize :moves, coder: JSON

  enum :status, { waiting: "waiting", playing: "playing", finished: "finished" }, default: :waiting

  validates :name, presence: true, length: { in: 2..40 }
  validates :creator_token, presence: true

  before_validation :assign_defaults, on: :create

  scope :open, -> { where.not(status: :finished) }
  scope :recent, -> { order(last_activity_at: :desc) }
  scope :stale, -> {
    where(status: :finished).where(last_activity_at: ...FINISHED_TTL.ago)
      .or(where(last_activity_at: ...STALE_AFTER.ago))
  }

  def to_param = slug

  # ---- global limits -----------------------------------------------------
  def self.can_create?(creator_token)
    open.count < MAX_OPEN_ROOMS && !open.exists?(creator_token: creator_token)
  end

  def self.creation_error(creator_token)
    return "Limite global de #{MAX_OPEN_ROOMS} salas abertas atingido. Tente mais tarde." if open.count >= MAX_OPEN_ROOMS
    return "Você já tem uma sala aberta. Termine ou feche ela antes de criar outra." if open.exists?(creator_token: creator_token)
    nil
  end

  def self.cleanup_stale!
    stale.find_each(&:destroy)
  end

  # ---- game --------------------------------------------------------------
  def game
    @game ||= Chess::Game.new(moves)
  end

  def board = game.board

  def piece_at(square) = board[square]

  def turn = game.active_player # :white | :black

  def check? = board.check?

  def color_of(token)
    return nil if token.blank?
    return :white if white_token == token
    return :black if black_token == token
    nil
  end

  def player?(token) = color_of(token).present?
  def creator?(token) = creator_token == token
  def full? = white_token.present? && black_token.present?
  def seat_free?(color) = public_send("#{color}_token").blank?

  def name_of(color)
    public_send("#{color}_name").presence || "—"
  end

  # Legal destination squares for the piece on `square` (only for the side to move).
  # `generate_moves` returns SAN ("Nf3", "exd5", "e8=Q", "O-O"); extract the target square.
  def legal_targets(square)
    return [] unless playing?
    rank = square[1]
    board.generate_moves(square).map do |san|
      case san
      when /\AO-O-O/ then "c#{rank}"
      when /\AO-O/   then "g#{rank}"
      else san.sub(/[+#]\z/, "").sub(/=[QRBN]\z/, "")[-2..]
      end
    end.uniq
  rescue Chess::Error, ArgumentError
    []
  end

  def own_piece?(color, square)
    piece = piece_at(square) or return false
    (color == :white) == (piece == piece.upcase)
  end

  def sit!(token, name, color)
    color = color.to_s
    raise Error, "Cor inválida." unless COLORS.include?(color)
    raise Error, "A partida já terminou." if finished?
    raise Error, "Você já está sentado nesta sala." if player?(token)
    raise Error, "Esse lugar já está ocupado." unless seat_free?(color)

    assign_attributes("#{color}_token" => token, "#{color}_name" => name)
    self.status = :playing if full?
    touch_activity
    save!
  end

  def play!(token, from, to, promotion = nil)
    color = color_of(token) or raise Error, "Você é espectador nesta sala."
    raise Error, "A partida ainda não começou." unless playing?
    raise Error, "Não é a sua vez." unless turn == color
    raise Error, "Lance inválido." unless square?(from) && square?(to)

    if promotion.blank? && promotion_move?(from, to)
      raise PromotionNeeded.new(from, to)
    end
    promotion = promotion.to_s.downcase
    raise Error, "Promoção inválida." unless promotion.empty? || %w[q r b n].include?(promotion)

    game.move("#{from}#{to}#{promotion}")
    self.moves = game.moves
    finish_if_over
    touch_activity
    save!
  rescue Chess::IllegalMoveError, Chess::BadNotationError
    @game = nil
    raise Error, "Lance ilegal."
  end

  def resign!(token)
    color = color_of(token) or raise Error, "Você é espectador nesta sala."
    raise Error, "A partida já terminou." if finished?
    return leave!(token) if waiting?

    game.resign(color)
    finish_if_over
    touch_activity
    save!
  end

  # Before the game starts a player may leave the seat.
  def leave!(token)
    color = color_of(token) or return
    assign_attributes("#{color}_token" => nil, "#{color}_name" => nil)
    touch_activity
    save!
  end

  def status_text
    case status
    when "waiting"  then "Aguardando jogadores"
    when "playing"  then "#{turn == :white ? 'Brancas' : 'Pretas'} jogam#{check? ? ' — xeque!' : ''}"
    when "finished" then result_text
    end
  end

  def result_text
    case result
    when "white_won"           then "Xeque-mate! Brancas venceram"
    when "black_won"           then "Xeque-mate! Pretas venceram"
    when "white_won_resign"    then "Pretas desistiram. Brancas venceram"
    when "black_won_resign"    then "Brancas desistiram. Pretas venceram"
    when "stalemate"           then "Empate por afogamento"
    when "insufficient_material" then "Empate por material insuficiente"
    when "fifty_move_rule"     then "Empate pela regra dos 50 lances"
    when "threefold_repetition" then "Empate por tripla repetição"
    when "abandoned"           then "Partida abandonada"
    else "Terminada"
    end
  end

  # Moves grouped as [number, white, black] for the view.
  def move_pairs
    moves.each_slice(2).with_index(1).map { |(w, b), n| [ n, w, b ] }
  end

  def touch_activity
    self.last_activity_at = Time.current
  end

  # Tells everyone in the room (Turbo Streams / Action Cable) that something changed.
  # Each client then fetches its own state through htmx.
  def broadcast_refresh
    Turbo::StreamsChannel.broadcast_replace_to(self, target: "refresh", partial: "rooms/refresh", locals: { room: self })
  end

  private

  def square?(sq) = sq.to_s.match?(/\A[a-h][1-8]\z/)

  def promotion_move?(from, to)
    piece = piece_at(from)
    piece&.downcase == "p" && to.end_with?(piece == "P" ? "8" : "1")
  end

  def finish_if_over
    return unless game.over?
    self.status = :finished
    self.result = game.status.to_s
  end

  def assign_defaults
    self.slug ||= SecureRandom.alphanumeric(8).downcase
    self.moves ||= []
    self.last_activity_at ||= Time.current
  end
end
