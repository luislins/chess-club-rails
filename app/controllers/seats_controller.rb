class SeatsController < ApplicationController
  include RoomScoped

  rate_limit to: 10, within: 1.minute, with: -> { render_rate_limited }

  # POST /rooms/:slug/seat  (color=white|black)
  def create
    @room.sit!(player_token, current_nickname, params[:color])
    @room.broadcast_refresh
    render_state
  rescue Room::Error => e
    render_error(e.message)
  end

  # DELETE /rooms/:slug/seat — levantar antes da partida começar
  def destroy
    return render_error("A partida já começou. Use 'Desistir'.") unless @room.waiting?

    @room.leave!(player_token)
    @room.broadcast_refresh
    render_state
  end
end
