# First visit: ask for a name before showing the rooms.
class WelcomeController < ApplicationController
  skip_before_action :require_player

  rate_limit to: 5, within: 1.minute, only: :create, with: -> { redirect_to welcome_path, alert: "Calma! Tente de novo em instantes." }

  def show
    return redirect_to root_path if current_player

    @theme = Arena::Theme.for
    if session[:nickname].present?
      flash.now[:alert] = "Alguém já entrou hoje como #{session[:nickname]}. Escolha outro nome."
    end
  end

  def create
    player = Player.enroll(player_token, params[:nickname])
    if player.persisted?
      session[:nickname] = player.name
      redirect_to session.delete(:return_to) || root_path
    else
      @theme = Arena::Theme.for
      flash.now[:alert] = player.errors.full_messages.to_sentence
      render :show, status: :unprocessable_entity
    end
  end
end
