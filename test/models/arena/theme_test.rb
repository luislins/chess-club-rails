require "test_helper"

module Arena
  class ThemeTest < ActiveSupport::TestCase
    test "every opening is a legal move sequence" do
      Theme::OPENINGS.each_value do |(_, moves)|
        assert_nothing_raised { Chess::Game.new(moves) }
      end
    end

    test "every special position loads" do
      Theme::SPECIALS.each_value do |(_, _, fen)|
        assert_nothing_raised { Chess::Game.load_fen(fen) }
      end
    end

    test "schedule: wednesdays opening, saturdays special, otherwise classic" do
      assert Theme.for(Date.new(2026, 9, 28)).classic?          # monday
      assert_match(/Abertura/, Theme.for(Date.new(2026, 9, 30)).name) # wednesday
      assert_match(/Especial/, Theme.for(Date.new(2026, 10, 3)).name) # saturday
      assert Theme.find("opening:nope").classic?
    end

    test "a room with a preset opening starts after those moves" do
      room = Room.create!(name: "Ruy", creator_token: "a", theme_key: "opening:ruy_lopez")
      room.sit!("a", "A", :white)
      room.sit!("b", "B", :black)
      assert_equal :black, room.turn
      assert_equal "B", room.piece_at("b5")
      room.play!("b", "a7", "a6")
      assert_equal [ "a6" ], room.reload.moves
      assert_equal [ [ 1, [ "e4", true ], [ "e5", true ] ], [ 2, [ "Nf3", true ], [ "Nc6", true ] ], [ 3, [ "Bb5", true ], [ "a6", false ] ] ], room.move_pairs
    end

    test "a room with a FEN theme plays from that position" do
      room = Room.create!(name: "Peões", creator_token: "a", theme_key: "special:peoes")
      room.sit!("a", "A", :white)
      room.sit!("b", "B", :black)
      assert_nil room.piece_at("d1")
      room.play!("a", "e2", "e4")
      room.play!("b", "e7", "e5")
      assert_equal %w[e4 e5], room.reload.moves
      assert_equal "P", room.piece_at("e4")
    end
  end
end
