class MovesController < ApplicationController
  include RoomScoped


  # POST /rooms/:slug/moves  (from=e2 to=e4 [promotion=q])
  def create
    @room.play!(player_token, params[:from].to_s, params[:to].to_s, params[:promotion])
    @room.broadcast_refresh
    render_state
  rescue Room::PromotionNeeded => e
    render_state(promotion: { from: e.from, to: e.to })
  rescue Room::Error => e
    render_error(e.message)
  end
end
