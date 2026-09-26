# Today's ranking. Everything resets at midnight.
class RankController < ApplicationController
  def show
    @day = Arena.today
    @theme = Arena::Theme.for(@day)
    @players = Player.today.ranked.limit(50)
    @games_count = Game.on(@day).counted.count
    @rooms_playing = Room.playing.count
    @midnight = Time.zone.now.end_of_day
  end
end
