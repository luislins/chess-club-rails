# Removes abandoned/finished rooms. Scheduled in config/recurring.yml (Solid Queue)
# and also triggered from the admin area.
class RoomCleanupJob < ApplicationJob
  queue_as :default

  def perform
    Room.cleanup_stale!
  end
end
