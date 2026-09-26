require "test_helper"

module Arena
  class ScorerTest < ActiveSupport::TestCase
    SCHOLARS_MATE = %w[e2e4 e7e5 f1c4 b8c6 d1h5 g8f6 h5f7].freeze
    TEN_QUIET_MOVES = %w[a2a3 a7a6 b2b3 b7b6 c2c3 c7c6 d2d3 d7d6 e2e3 e7e6].freeze

    setup do
      @alice = Player.enroll("tok-a", "Alice")
      @bob   = Player.enroll("tok-b", "Bob")
      @eve   = Player.enroll("tok-e", "Eve")
    end

    def play(white:, black:, moves:, resign: nil, name: "Sala")
      room = Room.create!(name: name, creator_token: white.token)
      room.sit!(white.token, white.name, :white)
      room.sit!(black.token, black.name, :black)
      moves.each_with_index { |m, i| room.play!(i.even? ? white.token : black.token, m[0, 2], m[2, 2]) }
      room.resign!(resign.token) if resign
      room
    end

    test "checkmate awards win points and records a counted game" do
      room = play(white: @alice, black: @bob, moves: SCHOLARS_MATE)
      assert room.finished?
      game = Game.find_by(room_id: room.id)
      assert game.counted
      assert_equal 7, game.moves_count
      assert_equal [ WIN_POINTS, 1, 1 ], [ @alice.reload.points, @alice.wins, @alice.streak ]
      assert_equal [ 0, 1, 0 ], [ @bob.reload.points, @bob.losses, @bob.streak ]
    end

    test "resignation only counts after the minimum number of moves" do
      play(white: @alice, black: @bob, moves: %w[e2e4 e7e5], resign: @bob)
      assert_not Game.last.counted
      assert_equal 0, @alice.reload.points

      play(white: @alice, black: @bob, moves: TEN_QUIET_MOVES, resign: @bob)
      assert Game.last.counted
      assert_equal WIN_POINTS, @alice.reload.points
    end

    test "draw gives one point to each side" do
      play(white: @alice, black: @bob, moves: TEN_QUIET_MOVES + %w[f2f3 f7f6])
      room = Room.last
      room.game.draw # agreed draw, straight through the engine
      room.update!(status: :finished, result: "draw")
      assert_equal DRAW_POINTS, @alice.reload.points
      assert_equal DRAW_POINTS, @bob.reload.points
      assert_equal 1, @bob.draws
    end

    test "streak bonus from the third consecutive win" do
      3.times { |i| play(white: @alice, black: [ @bob, @eve, @bob ][i], moves: SCHOLARS_MATE) }
      assert_equal WIN_POINTS * 3 + STREAK_BONUS, @alice.reload.points
      assert_equal 3, @alice.streak
    end

    test "beating the current leader pays the king bonus" do
      play(white: @bob, black: @eve, moves: SCHOLARS_MATE) # Bob leads with 3
      assert_equal @bob, Player.leader
      play(white: @alice, black: @bob, moves: SCHOLARS_MATE)
      assert_equal WIN_POINTS + KING_BONUS, @alice.reload.points
    end

    test "only a few games per pair count each day" do
      (MAX_GAMES_PER_PAIR + 1).times { play(white: @alice, black: @bob, moves: SCHOLARS_MATE) }
      assert_equal MAX_GAMES_PER_PAIR, Game.counted.count
      assert_equal WIN_POINTS * MAX_GAMES_PER_PAIR + STREAK_BONUS, @alice.reload.points # third win in a row
    end

    test "games against yourself or unknown players do not count" do
      room = Room.create!(name: "Solo", creator_token: "ghost")
      room.sit!("ghost", "Ghost", :white)
      room.sit!(@bob.token, @bob.name, :black)
      SCHOLARS_MATE.each_with_index { |m, i| room.play!(i.even? ? "ghost" : @bob.token, m[0, 2], m[2, 2]) }
      assert_not Game.last.counted
    end

    test "correct predictions earn a point, wrong ones just count" do
      room = Room.create!(name: "Sala", creator_token: @alice.token)
      room.sit!(@alice.token, @alice.name, :white)
      room.sit!(@bob.token, @bob.name, :black)
      assert room.predictions_open?
      room.predictions.create!(player: @eve, color: "white")
      other = Player.enroll("tok-o", "Otto")
      room.predictions.create!(player: other, color: "black")

      SCHOLARS_MATE.each_with_index { |m, i| room.play!(i.even? ? @alice.token : @bob.token, m[0, 2], m[2, 2]) }

      assert_equal [ PREDICTION_POINTS, 1, 1 ], [ @eve.reload.points, @eve.predictions_correct, @eve.predictions_total ]
      assert_equal [ 0, 0, 1 ], [ other.reload.points, other.predictions_correct, other.predictions_total ]
    end

    test "predictions close after the deadline" do
      room = play(white: @alice, black: @bob, moves: TEN_QUIET_MOVES)
      assert_not room.predictions_open?
    end
  end
end
