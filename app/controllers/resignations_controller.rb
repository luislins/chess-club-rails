class ResignationsController < ApplicationController
  include RoomScoped


  # POST /rooms/:slug/resignation
  def create
    @room.resign!(player_token)
    @room.broadcast_refresh
    render_state
  rescue Room::Error => e
    render_error(e.message)
  end
end
