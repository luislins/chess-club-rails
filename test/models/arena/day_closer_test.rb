require "test_helper"

module Arena
  class DayCloserTest < ActiveSupport::TestCase
    test "writes the hall of fame entry for the day" do
      day = Arena.today
      alice = Player.create!(day: day, token: "a", name: "Alice", points: 7, wins: 2)
      Player.create!(day: day, token: "b", name: "Bob", points: 3, wins: 1)
      eve = Player.create!(day: day, token: "e", name: "Eve", points: 2, predictions_correct: 2, predictions_total: 3)
      Game.create!(day: day, room_name: "x", white_player: alice, black_player: eve, result: "white_won", moves_count: 12, counted: true)
      Game.create!(day: day, room_name: "y", white_player: alice, black_player: eve, result: "black_won_resign", moves_count: 40, counted: true)
      Game.create!(day: day, room_name: "z", white_player: alice, black_player: eve, result: "white_won", moves_count: 4, counted: false)

      champion = DayCloser.close(day)
      assert champion.persisted?
      assert_equal "Alice", champion.champion_name
      assert_equal 7, champion.champion_points
      assert_equal "Eve", champion.best_predictor_name
      assert_equal "Alice", champion.fastest_mate_winner
      assert_equal 12, champion.fastest_mate_moves
      assert_equal 40, champion.longest_game_moves
      assert_equal 2, champion.games_count
      assert_equal 3, champion.players_count

      assert_no_difference("Champion.count") { DayCloser.close(day) }
    end

    test "the job closes yesterday only when someone played" do
      assert_no_difference("Champion.count") { ArenaCloseJob.perform_now }
      Player.create!(day: Arena.today - 1, token: "a", name: "Alice", points: 1)
      assert_difference("Champion.count", 1) { ArenaCloseJob.perform_now }
    end
  end
end
