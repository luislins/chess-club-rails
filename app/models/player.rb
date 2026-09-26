# A player of the day. Identified by the anonymous session token; the name is
# unique within the day (first come, first served) so the ranking is unambiguous.
class Player < ApplicationRecord
  NAME_LENGTH = 2..20

  has_many :predictions, dependent: :delete_all

  validates :day, :token, presence: true
  validates :name, presence: true, length: { in: NAME_LENGTH }
  validates :token, uniqueness: { scope: :day }
  validate :name_is_free_today

  scope :today,  -> { where(day: Arena.today) }
  scope :ranked, -> { order(points: :desc, wins: :desc, predictions_correct: :desc, id: :asc) }
  scope :scored, -> { where("points > 0") }

  def self.normalize_name(name) = name.to_s.squish.first(NAME_LENGTH.max)

  # Enrolls a token in today's arena. Returns the player, or an invalid record
  # when the name is taken (or bad).
  def self.enroll(token, name, day: Arena.today)
    find_by(day: day, token: token) || create(day: day, token: token, name: normalize_name(name))
  end

  def self.leader(day = Arena.today)
    where(day: day).scored.ranked.first
  end

  def leader? = self == Player.leader(day)

  def rename(new_name)
    update(name: self.class.normalize_name(new_name))
  end

  def games_played = wins + draws + losses

  private

  def name_is_free_today
    return if name.blank?
    taken = Player.where(day: day).where("lower(name) = ?", name.downcase).where.not(id: id).exists?
    errors.add(:name, "já está em uso hoje, escolha outro") if taken
  end
end
