require "test_helper"

# Fluxo completo com dois "navegadores" (sessões) diferentes.
class RoomsFlowTest < ActionDispatch::IntegrationTest
  HX = { "HX-Request" => "true" }

  test "create, sit, move, chat, resign and close a room" do
    white = open_session
    black = open_session

    white.get root_path
    assert_response_ok white
    white.post rooms_path, params: { room: { name: "Sala X" } }
    room = Room.last
    assert_redirected_to_room white, room

    # o criador não pode abrir uma segunda sala
    white.post rooms_path, params: { room: { name: "Sala Y" } }
    assert_equal 1, Room.count
    assert_match(/já tem uma sala/, white.flash[:alert])

    white.post room_seat_path(room, color: :white), headers: HX
    assert_response_ok white
    assert_includes white.response.body, "Você joga de <strong>Brancas"

    black.get room_path(room)
    assert_response_ok black
    assert_includes black.response.body, "Você está assistindo"
    black.post room_seat_path(room, color: :black), headers: HX
    assert room.reload.playing?
    assert_includes black.response.body, 'class="board flipped'

    # espectador não consegue jogar
    spectator = open_session
    spectator.post room_moves_path(room), params: { from: "e2", to: "e4" }, headers: HX
    assert_equal 422, spectator.response.status
    assert_includes spectator.response.body, "espectador"

    white.get state_room_path(room, from: "e2"), headers: HX
    assert_includes white.response.body, 'data-square="e4"'
    assert_match(/class="sq [^"]*target[^"]*" data-square="e4"/, white.response.body)

    white.post room_moves_path(room), params: { from: "e2", to: "e4" }, headers: HX
    assert_response_ok white
    assert_equal [ "e4" ], room.reload.moves
    assert_includes white.response.body, "Pretas jogam"

    white.post room_moves_path(room), params: { from: "d2", to: "d4" }, headers: HX
    assert_equal 422, white.response.status
    assert_includes white.response.body, "Não é a sua vez"

    black.post room_messages_path(room), params: { body: "oi" }, headers: HX
    assert_equal 204, black.response.status
    assert_equal "oi", room.messages.last.body

    black.post room_messages_path(room), params: { body: "" }, headers: HX
    assert_equal 422, black.response.status

    black.post room_resignation_path(room), headers: HX
    assert room.reload.finished?
    assert_includes black.response.body, "Pretas desistiram"

    # só o criador fecha a sala
    black.delete room_path(room), headers: HX
    assert_equal 403, black.response.status
    white.delete room_path(room), headers: HX
    assert_equal root_path, white.response.headers["HX-Redirect"]
    assert_equal 0, Room.count
  end

  test "nickname is stored in the session and used in chat" do
    room = Room.create!(name: "Sala", creator_token: "x")
    patch nickname_path, params: { nickname: "Luis" }, headers: HX
    assert_response :ok
    assert_includes response.body, 'value="Luis"'
    post room_messages_path(room), params: { body: "olá" }, headers: HX
    assert_equal "Luis", room.messages.last.nickname
  end

  private

  def assert_response_ok(session) = assert_equal 200, session.response.status
  def assert_redirected_to_room(session, room) = assert_equal room_url(room), session.response.location
end
