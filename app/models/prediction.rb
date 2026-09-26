# A spectator's guess about who wins a game.
class Prediction < ApplicationRecord
  belongs_to :room
  belongs_to :player

  validates :color, inclusion: { in: Room::COLORS }
  validates :player_id, uniqueness: { scope: :room_id }
end
