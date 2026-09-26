class MovesController < ApplicationController
  include RoomScoped

  rate_limit to: 30, within: 10.seconds, with: -> { render_rate_limited }

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
