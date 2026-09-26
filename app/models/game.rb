# A finished game, kept after the room is gone.
class Game < ApplicationRecord
  belongs_to :white_player, class_name: "Player", optional: true
  belongs_to :black_player, class_name: "Player", optional: true

  scope :on,      ->(day) { where(day: day) }
  scope :counted, -> { where(counted: true) }
  scope :checkmates, -> { where(result: %w[white_won black_won]) }

  def checkmate? = %w[white_won black_won].include?(result)
  def draw?      = !result.start_with?("white_won", "black_won")

  def winner_color
    return :white if result.start_with?("white_won")
    return :black if result.start_with?("black_won")
    nil
  end

  def winner = winner_color == :white ? white_player : (winner_color == :black ? black_player : nil)
  def loser  = winner_color == :white ? black_player : (winner_color == :black ? white_player : nil)
end
