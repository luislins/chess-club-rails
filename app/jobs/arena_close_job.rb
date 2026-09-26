# Closes a day of the arena (defaults to yesterday). Scheduled just after
# midnight in config/recurring.yml and also available from the admin area.
class ArenaCloseJob < ApplicationJob
  queue_as :default

  def perform(day = Arena.today - 1)
    Arena::DayCloser.close(day) if Player.where(day: day).exists?
  end
end
