class Message < ApplicationRecord
  belongs_to :room

  validates :nickname, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 300 }

  after_create_commit :broadcast_to_room
  after_create_commit :trim_room_history

  private

  def broadcast_to_room
    broadcast_append_to room, target: "messages"
  end

  def trim_room_history
    excess = room.messages.count - Room::MAX_MESSAGES
    room.messages.order(:id).limit(excess).delete_all if excess.positive?
  end
end
