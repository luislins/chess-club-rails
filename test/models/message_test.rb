require "test_helper"

class MessageTest < ActiveSupport::TestCase
  setup { @room = Room.create!(name: "Sala", creator_token: "c") }

  test "validates presence and length" do
    assert_not @room.messages.build(nickname: "a", body: "").valid?
    assert_not @room.messages.build(nickname: "", body: "oi").valid?
    assert_not @room.messages.build(nickname: "a", body: "x" * 301).valid?
    assert @room.messages.build(nickname: "a", body: "oi").valid?
  end

  test "keeps only the last MAX_MESSAGES per room" do
    (Room::MAX_MESSAGES + 5).times { |i| @room.messages.create!(nickname: "a", body: "m#{i}") }
    assert_equal Room::MAX_MESSAGES, @room.messages.count
    assert_equal "m5", @room.messages.order(:id).first.body
  end
end
