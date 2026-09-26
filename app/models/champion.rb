# Hall of fame entry: the recap of one day, written when the day closes.
class Champion < ApplicationRecord
  validates :day, presence: true, uniqueness: true

  scope :recent, -> { order(day: :desc) }

  def theme = Arena::Theme.for(day)
end
