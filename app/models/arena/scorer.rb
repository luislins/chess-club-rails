# Turns a finished room into a Game row and hands out the day's points.
module Arena
  class Scorer
    def self.record(room) = new(room).record

    def initialize(room)
      @room = room
      @day  = Arena.today
    end

    def record
      return if @room.result.blank? || Game.exists?(room_id: @room.id)

      white = Player.find_by(day: @day, token: @room.white_token)
      black = Player.find_by(day: @day, token: @room.black_token)

      Game.transaction do
        game = Game.create!(
          day: @day, room_id: @room.id, room_name: @room.name, theme_key: @room.theme_key,
          white_player: white, black_player: black, result: @room.result,
          moves_count: @room.moves.size, counted: counts?(white, black)
        )
        award(game) if game.counted
        game
      end
    end

    private

    def counts?(white, black)
      return false unless white && black && white != black
      return false if @room.result == "abandoned"
      return false unless @room.checkmate_result? || @room.moves.size >= MIN_MOVES
      Game.on(@day).counted.where(white_player: [ white, black ], black_player: [ white, black ]).count < MAX_GAMES_PER_PAIR
    end

    def award(game)
      leader_before = Player.leader(@day)

      if (winner = game.winner)
        loser = game.loser
        points = WIN_POINTS
        points += STREAK_BONUS if winner.streak >= STREAK_THRESHOLD
        points += KING_BONUS   if leader_before && leader_before == loser
        winner.update!(points: winner.points + points, wins: winner.wins + 1, streak: winner.streak + 1)
        loser.update!(losses: loser.losses + 1, streak: 0)
      else
        [ game.white_player, game.black_player ].each do |p|
          p.update!(points: p.points + DRAW_POINTS, draws: p.draws + 1, streak: 0)
        end
      end

      settle_predictions(game)
    end

    def settle_predictions(game)
      @room.predictions.includes(:player).find_each do |prediction|
        player = prediction.player
        next if player.day != @day
        correct = prediction.color.to_sym == game.winner_color
        player.update!(
          predictions_total: player.predictions_total + 1,
          predictions_correct: player.predictions_correct + (correct ? 1 : 0),
          points: player.points + (correct ? PREDICTION_POINTS : 0)
        )
      end
    end
  end
end
