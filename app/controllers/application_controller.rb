class ApplicationController < ActionController::Base
  # Only allow modern browsers (webp, web push, badges, import maps, CSS nesting and :has).
  allow_browser versions: :modern

  before_action :ensure_player_token
  before_action :require_nickname

  helper_method :player_token, :current_nickname, :htmx_request?

  private

  # No authentication: each browser gets a random token in the (encrypted) session
  # cookie. That token is the player's identity.
  def ensure_player_token
    session[:player_token] ||= SecureRandom.hex(16)
  end

  def player_token = session[:player_token]

  # First visit: send the user to the welcome screen to pick a name, then bring
  # them back to where they were going (e.g. a room link a friend shared).
  def require_nickname
    return if session[:nickname].present?

    if htmx_request?
      response.set_header("HX-Redirect", welcome_path)
      head :ok
    else
      session[:return_to] = request.fullpath if request.get?
      redirect_to welcome_path
    end
  end

  def current_nickname
    session[:nickname].presence || "Anônimo-#{player_token.to_s.first(4)}"
  end

  def htmx_request? = request.headers["HX-Request"].present?

  # Error rendered into #flash through an htmx out-of-band swap.
  def render_error(message, status: :unprocessable_entity)
    render partial: "shared/flash", locals: { error: message }, status: status
  end

  def render_rate_limited
    render_error("Calma! Muitas requisições. Tente de novo em instantes.", status: :too_many_requests)
  end
end
