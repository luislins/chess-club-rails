class PredictionsController < ApplicationController
  include RoomScoped

  rate_limit to: 10, within: 1.minute, with: -> { render_rate_limited }

  # POST /rooms/:slug/prediction  (color=white|black)
  # Spectators guess the winner; they can change their mind until the deadline.
  def create
    return render_error("Jogadores não dão palpite na própria partida.") if @room.player?(player_token)
    return render_error("Os palpites estão encerrados para esta partida.") unless @room.predictions_open?

    prediction = @room.predictions.find_or_initialize_by(player: current_player)
    prediction.color = params[:color].to_s
    return render_error("Palpite inválido.") unless prediction.save

    @room.broadcast_refresh
    render_state
  end
end
