# First visit: ask for a name before showing the rooms.
class WelcomeController < ApplicationController
  skip_before_action :require_nickname

  rate_limit to: 5, within: 1.minute, only: :create, with: -> { redirect_to welcome_path, alert: "Calma! Tente de novo em instantes." }

  def show
    redirect_to root_path if session[:nickname].present?
  end

  def create
    nickname = params[:nickname].to_s.squish.first(20)
    if nickname.length < 2
      flash.now[:alert] = "Escolha um nome com pelo menos 2 letras."
      return render :show, status: :unprocessable_entity
    end

    session[:nickname] = nickname
    redirect_to session.delete(:return_to) || root_path
  end
end
