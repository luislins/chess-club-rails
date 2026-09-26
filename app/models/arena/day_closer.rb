# Writes the hall of fame entry for a day. Idempotent: running it again
# refreshes the numbers.
module Arena
  class DayCloser
    def self.close(day) = new(day).close

    def initialize(day)
      @day = day
    end

    def close
      recap.tap(&:save!)
    end

    # The (unsaved) recap of the day, also used for the live page of today.
    def recap
      champion  = Player.leader(@day)
      predictor = Player.where(day: @day).where("predictions_correct > 0").order(predictions_correct: :desc, points: :desc, id: :asc).first
      games     = Game.on(@day).counted
      mate      = games.checkmates.order(:moves_count, :id).first
      longest   = games.order(moves_count: :desc, id: :asc).first

      Champion.find_or_initialize_by(day: @day).tap do |c|
        c.assign_attributes(
          champion_name: champion&.name, champion_points: champion&.points,
          best_predictor_name: predictor&.name, best_predictor_correct: predictor&.predictions_correct,
          fastest_mate_winner: mate&.winner&.name, fastest_mate_moves: mate&.moves_count,
          longest_game_moves: longest&.moves_count,
          games_count: games.count, players_count: Player.where(day: @day).count
        )
      end
    end
  end
end
