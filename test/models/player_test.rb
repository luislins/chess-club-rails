require "test_helper"

class PlayerTest < ActiveSupport::TestCase
  test "names are unique per day, case-insensitively" do
    Player.enroll("a", "Luis")
    dup = Player.enroll("b", "luis")
    assert_not dup.persisted?
    assert_match(/em uso hoje/, dup.errors.full_messages.to_sentence)
    assert Player.enroll("b", "Luis", day: Arena.today + 1).persisted?
  end

  test "enroll is idempotent for the same token" do
    p1 = Player.enroll("a", "Luis")
    p2 = Player.enroll("a", "Outro nome")
    assert_equal p1, p2
  end

  test "normalizes and validates the name" do
    assert_equal "Luis Lins", Player.enroll("a", "  Luis   Lins ").name
    assert_not Player.enroll("b", "L").persisted?
  end

  test "leader is the top scorer, nobody when nobody scored" do
    a = Player.enroll("a", "Ana")
    assert_nil Player.leader
    a.update!(points: 3)
    assert_equal a, Player.leader
  end
end
