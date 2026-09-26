class SeatsController < ApplicationController
  include RoomScoped


  # POST /rooms/:slug/seat  (color=white|black)
  def create
    @room.sit!(player_token, current_nickname, params[:color])
    @room.broadcast_refresh
    render_state
  rescue Room::Error => e
    render_error(e.message)
  end

  # DELETE /rooms/:slug/seat - stand up before the game starts
  def destroy
    return render_error("A partida já começou. Use 'Desistir'.") unless @room.waiting?

    @room.leave!(player_token)
    @room.broadcast_refresh
    render_state
  end
end
