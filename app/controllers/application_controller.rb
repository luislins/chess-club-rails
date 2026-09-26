class ApplicationController < ActionController::Base
  # Only allow modern browsers (webp, web push, badges, import maps, CSS nesting and :has).
  allow_browser versions: :modern

  before_action :ensure_player_token

  helper_method :player_token, :current_nickname, :htmx_request?

  private

  # No authentication: each browser gets a random token in the (encrypted) session
  # cookie. That token is the player's identity.
  def ensure_player_token
    session[:player_token] ||= SecureRandom.hex(16)
  end

  def player_token = session[:player_token]

  def current_nickname
    session[:nickname].presence || "Anônimo-#{player_token.to_s.first(4)}"
  end

  def htmx_request? = request.headers["HX-Request"].present?

  # Error rendered into #flash through an htmx out-of-band swap.
  def render_error(message, status: :unprocessable_entity)
    render partial: "shared/flash", locals: { error: message }, status: status
  end

end
