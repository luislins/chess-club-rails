# Remove salas abandonadas/terminadas. Agendado em config/recurring.yml (Solid Queue)
# e também disparável pelo admin.
class RoomCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Room.cleanup_stale!
  end
end
