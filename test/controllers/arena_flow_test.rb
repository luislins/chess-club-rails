require "test_helper"

class ArenaFlowTest < ActionDispatch::IntegrationTest
  HX = { "HX-Request" => "true" }

  # Rooms created through the controller get the theme of the day; pin a
  # classic (Monday) day so the scholar's mate below is always legal.
  setup { travel_to Time.zone.local(2026, 9, 28, 12) }

  test "welcome enforces unique names and re-enrolls returning visitors" do
    post welcome_path, params: { nickname: "Alice" }
    assert_redirected_to root_path
    assert_equal "Alice", Player.today.first.name

    other = open_session
    other.post welcome_path, params: { nickname: "alice" }
    assert_equal 422, other.response.status
    assert_includes other.response.body, "em uso hoje"

    # a new day: the same browser gets re-enrolled automatically
    travel_to Arena.today.tomorrow.in_time_zone.noon do
      get root_path
      assert_response :ok
      assert_equal 1, Player.today.count
      assert_equal "Alice", Player.today.first.name
    end
  end

  test "spectator predicts, players finish, rank and recap pages show it" do
    white = open_session
    black = open_session
    fan   = open_session
    white.post welcome_path, params: { nickname: "Alice" }
    black.post welcome_path, params: { nickname: "Bob" }
    fan.post welcome_path, params: { nickname: "Eve" }

    white.post rooms_path, params: { room: { name: "Sala" } }
    room = Room.last
    white.post room_seat_path(room, color: :white), headers: HX
    black.post room_seat_path(room, color: :black), headers: HX

    # a player cannot predict, a fan can and may change their mind
    white.post room_prediction_path(room, color: :black), headers: HX
    assert_equal 422, white.response.status
    fan.post room_prediction_path(room, color: :black), headers: HX
    fan.post room_prediction_path(room, color: :white), headers: HX
    assert_equal 200, fan.response.status
    assert_includes fan.response.body, "Seu palpite: Brancas"
    assert_equal({ white: 1, black: 0 }, room.prediction_counts)

    %w[e2e4 e7e5 f1c4 b8c6 d1h5 g8f6 h5f7].each_with_index do |m, i|
      (i.even? ? white : black).post room_moves_path(room), params: { from: m[0, 2], to: m[2, 2] }, headers: HX
    end
    assert room.reload.finished?

    alice, bob, eve = %w[Alice Bob Eve].map { |n| Player.today.find_by(name: n) }
    assert_equal Arena::WIN_POINTS, alice.points
    assert_equal 0, bob.points
    assert_equal Arena::PREDICTION_POINTS, eve.points

    fan.get rank_path
    assert_equal 200, fan.response.status
    assert_includes fan.response.body, "Alice 👑"
    assert_includes fan.response.body, "Eve (você)"

    fan.get day_path(Arena.today.iso8601)
    assert_includes fan.response.body, "Campeão:</strong> Alice"
    assert_includes fan.response.body, "Melhor palpiteiro:</strong> Eve"
    assert_includes fan.response.body, "Mate mais rápido:</strong> Alice em 7 lances"

    fan.get hall_path
    assert_includes fan.response.body, "Nenhum dia fechado ainda"
    Arena::DayCloser.close(Arena.today)
    fan.get hall_path
    assert_includes fan.response.body, "🏆 Alice (3 pts)"

    fan.get day_path((Arena.today + 1).iso8601)
    assert_equal hall_url, fan.response.location
  end

  test "faq is public" do
    get faq_path
    assert_response :ok
    assert_includes response.body, "Perguntas frequentes"
  end

  test "renaming keeps names unique and updates open rooms" do
    post welcome_path, params: { nickname: "Alice" }
    Player.enroll("other", "Bob")
    room = Room.create!(name: "Sala", creator_token: "x")
    room.sit!(Player.today.find_by(name: "Alice").token, "Alice", :white)

    patch nickname_path, params: { nickname: "Bob" }, headers: HX
    assert_equal 422, response.status
    patch nickname_path, params: { nickname: "Alicia" }, headers: HX
    assert_equal 200, response.status
    assert_equal "Alicia", room.reload.white_name
  end
end
