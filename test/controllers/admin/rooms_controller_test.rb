require "test_helper"

module Admin
  class RoomsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @room = Room.create!(name: "Sala", creator_token: "x")
      @room.messages.create!(nickname: "a", body: "oi")
    end

    test "requires basic auth" do
      get admin_root_path
      assert_response :unauthorized
      get admin_root_path, headers: auth("admin", "wrong")
      assert_response :unauthorized
      get admin_root_path, headers: auth("admin", "admin")
      assert_response :ok
      assert_includes response.body, "Sala"
    end

    test "can clear chat, close rooms and cleanup stale ones" do
      post clear_chat_admin_room_path(@room), headers: auth("admin", "admin")
      assert_equal 0, @room.messages.count

      Room.create!(name: "Velha", creator_token: "y", last_activity_at: 5.hours.ago)
      post cleanup_admin_rooms_path, headers: auth("admin", "admin")
      assert_equal [ @room ], Room.all.to_a

      delete admin_room_path(@room), headers: auth("admin", "admin")
      assert_redirected_to admin_root_path
      assert_equal 0, Room.count
    end

    private

    def auth(user, password)
      { "Authorization" => ActionController::HttpAuthentication::Basic.encode_credentials(user, password) }
    end
  end
end
