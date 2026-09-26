# The daily arena: everything resets at midnight (config.time_zone). Players,
# games and predictions belong to a day; only champions survive as a hall of fame.
module Arena
  WIN_POINTS        = 3
  DRAW_POINTS       = 1
  STREAK_BONUS      = 1   # extra point from the third consecutive win on
  STREAK_THRESHOLD  = 2   # wins in a row needed before the bonus kicks in
  KING_BONUS        = 2   # extra points for beating the current leader
  PREDICTION_POINTS = 1
  MIN_MOVES         = 10  # resignations/draws only count after this many moves (checkmate always counts)
  MAX_GAMES_PER_PAIR = 3  # games per day between the same two players that count
  PREDICTION_DEADLINE = 10 # spectators can predict until this many moves were played

  def self.today = Time.zone.today
end
