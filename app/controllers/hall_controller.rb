# Hall of fame (one entry per day) and the recap of a single day.
class HallController < ApplicationController
  def index
    @champions = Champion.recent.limit(60)
  end

  def show
    @day = Date.iso8601(params[:day])
    return redirect_to hall_path, alert: "Esse dia ainda não chegou." if @day > Arena.today

    @recap = Champion.find_by(day: @day) || Arena::DayCloser.new(@day).recap
    @players = Player.where(day: @day).scored.ranked.limit(10)
    @live = @day == Arena.today
  rescue Date::Error
    redirect_to hall_path
  end
end
