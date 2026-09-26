class NicknamesController < ApplicationController
  rate_limit to: 5, within: 1.minute, with: -> { render_rate_limited }

  # PATCH /nickname
  def update
    if current_player.rename(params[:nickname])
      session[:nickname] = current_player.name
      Room.open.where(white_token: player_token).update_all(white_name: current_player.name)
      Room.open.where(black_token: player_token).update_all(black_name: current_player.name)
      render partial: "nicknames/form", locals: { saved: true }
    else
      current_player.reload
      render partial: "nicknames/form", locals: { error: current_player.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end
end
