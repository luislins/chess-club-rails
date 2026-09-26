class ResignationsController < ApplicationController
  include RoomScoped

  rate_limit to: 5, within: 1.minute, with: -> { render_rate_limited }

  # POST /rooms/:slug/resignation
  def create
    @room.resign!(player_token)
    @room.broadcast_refresh
    render_state
  rescue Room::Error => e
    render_error(e.message)
  end
end
