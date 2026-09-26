require "test_helper"

class RoomTest < ActiveSupport::TestCase
  setup do
    @room = Room.create!(name: "Sala", creator_token: "creator")
  end

  def start_game
    @room.sit!("w", "Alice", :white)
    @room.sit!("b", "Bob", :black)
  end

  test "starts waiting with a slug and an empty move list" do
    assert @room.waiting?
    assert_match(/\A[a-z0-9]{8}\z/, @room.slug)
    assert_equal [], @room.moves
  end

  test "sitting on both seats starts the game" do
    @room.sit!("w", "Alice", :white)
    assert @room.waiting?
    @room.sit!("b", "Bob", :black)
    assert @room.playing?
    assert_equal :white, @room.color_of("w")
    assert_equal :black, @room.color_of("b")
    assert_nil @room.color_of("spectator")
  end

  test "cannot sit twice or on a taken seat" do
    @room.sit!("w", "Alice", :white)
    assert_raises(Room::Error) { @room.sit!("w", "Alice", :black) }
    assert_raises(Room::Error) { @room.sit!("x", "Eve", :white) }
    assert_raises(Room::Error) { @room.sit!("x", "Eve", :green) }
  end

  test "plays legal moves in turn and rejects the rest" do
    start_game
    @room.play!("w", "e2", "e4")
    assert_equal [ "e4" ], @room.reload.moves
    assert_equal :black, @room.turn

    assert_raises(Room::Error, "not your turn") { @room.play!("w", "d2", "d4") }
    assert_raises(Room::Error, "illegal")       { @room.play!("b", "a7", "a3") }
    assert_raises(Room::Error, "spectator")     { @room.play!("s", "e7", "e5") }
    assert_equal [ "e4" ], @room.reload.moves
  end

  test "legal_targets returns destination squares including castling" do
    start_game
    %w[e2e4 e7e5 g1f3 b8c6 f1c4 g8f6].each_with_index do |m, i|
      @room.play!(i.even? ? "w" : "b", m[0, 2], m[2, 2])
    end
    assert_equal %w[f1 g1 e2].sort, @room.legal_targets("e1").sort
    assert_equal [], @room.legal_targets("e8") # not black's turn
  end

  test "promotion requires a piece choice" do
    start_game
    %w[a2a4 b7b5 a4b5 h7h6 b5b6 h6h5 b6a7 h5h4].each_with_index do |m, i|
      @room.play!(i.even? ? "w" : "b", m[0, 2], m[2, 2])
    end
    error = assert_raises(Room::PromotionNeeded) { @room.play!("w", "a7", "b8") }
    assert_equal "b8", error.to
    @room.play!("w", "a7", "b8", "q")
    assert_equal "Q", @room.piece_at("b8")
  end

  test "checkmate finishes the game" do
    start_game
    %w[e2e4 e7e5 f1c4 b8c6 d1h5 g8f6 h5f7].each_with_index do |m, i|
      @room.play!(i.even? ? "w" : "b", m[0, 2], m[2, 2])
    end
    assert @room.finished?
    assert_equal "white_won", @room.result
    assert_raises(Room::Error) { @room.play!("b", "e8", "f7") }
  end

  test "resigning finishes the game, leaving before start frees the seat" do
    @room.sit!("w", "Alice", :white)
    @room.resign!("w")
    assert @room.waiting?
    assert @room.seat_free?(:white)

    start_game
    @room.resign!("b")
    assert @room.finished?
    assert_equal "white_won_resign", @room.result # black resigned => white won
  end

  test "global limits: max open rooms and one open room per creator" do
    assert_match(/já tem uma sala/, Room.creation_error("creator"))
    assert_nil Room.creation_error("someone-else")

    (Room::MAX_OPEN_ROOMS - 1).times { |i| Room.create!(name: "Sala #{i}", creator_token: "c#{i}") }
    assert_match(/Limite global/, Room.creation_error("someone-else"))
  end

  test "stale scope covers abandoned and old finished rooms" do
    fresh    = Room.create!(name: "Fresh", creator_token: "1")
    old      = Room.create!(name: "Old", creator_token: "2", last_activity_at: 3.hours.ago)
    finished = Room.create!(name: "Done", creator_token: "3", status: :finished, last_activity_at: 2.hours.ago)
    just_done = Room.create!(name: "Just done", creator_token: "4", status: :finished, last_activity_at: 5.minutes.ago)

    assert_equal [ old, finished ].sort, Room.stale.to_a.sort
    Room.cleanup_stale!
    assert_equal [ @room, fresh, just_done ].sort, Room.all.to_a.sort
  end
end

class RoomClockTest < ActiveSupport::TestCase
  setup do
    @room = Room.create!(name: "Blitz", creator_token: "c", time_control: 180)
    @room.sit!("w", "Alice", :white)
    @room.sit!("b", "Bob", :black)
  end

  test "clocks start when both seats are taken" do
    assert_equal 180_000, @room.white_ms
    assert_equal 180_000, @room.black_ms
    assert @room.clock_running?(:white)
    assert_not @room.clock_running?(:black)
  end

  test "moving charges the mover and hands the clock over" do
    travel 20.seconds
    @room.play!("w", "e2", "e4")
    assert_in_delta 160_000, @room.white_ms, 1_000
    assert_equal 180_000, @room.black_ms
    assert @room.clock_running?(:black)
    travel 5.seconds
    assert_in_delta 175_000, @room.remaining_ms(:black), 1_000
  end

  test "running out of time loses the game" do
    travel 181.seconds
    assert_equal 0, @room.remaining_ms(:white)
    assert @room.check_timeout!
    assert @room.finished?
    assert_equal "black_won_time", @room.result
    assert_match(/perderam no tempo/, @room.status_text)
    assert_not @room.check_timeout!
  end

  test "a late move is refused and ends the game" do
    travel 181.seconds
    assert_raises(Room::Error) { @room.play!("w", "e2", "e4") }
    assert @room.finished?
  end

  test "time control must be one of the offered options" do
    assert_not Room.new(name: "x", creator_token: "c", time_control: 42).valid?
  end
end
