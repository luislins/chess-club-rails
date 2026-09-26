class ApplicationController < ActionController::Base
  # Only allow modern browsers (webp, web push, badges, import maps, CSS nesting and :has).
  allow_browser versions: :modern

  before_action :ensure_player_token
  before_action :require_player

  helper_method :player_token, :current_player, :current_nickname, :htmx_request?, :arena_leader

  private

  # No authentication: each browser gets a random token in the (encrypted) session
  # cookie. That token is the player's identity.
  def ensure_player_token
    session[:player_token] ||= SecureRandom.hex(16)
  end

  def player_token = session[:player_token]

  # Today's Player for this browser (nil until enrolled).
  def current_player
    @current_player ||= Player.find_by(day: Arena.today, token: player_token)
  end

  def current_nickname
    current_player&.name || session[:nickname].presence || "Anônimo"
  end

  def arena_leader
    return @arena_leader if defined?(@arena_leader)
    @arena_leader = Player.leader
  end

  # Every day starts fresh: returning visitors are re-enrolled with the name
  # they used before, as long as nobody took it today. First visits (or a
  # taken name) go to the welcome screen, then back to where they were going
  # (e.g. a room link a friend shared).
  def require_player
    return if current_player

    if session[:nickname].present?
      player = Player.enroll(player_token, session[:nickname])
      return @current_player = player if player.persisted?
    end

    if htmx_request?
      response.set_header("HX-Redirect", welcome_path)
      head :ok
    else
      session[:return_to] = request.fullpath if request.get?
      redirect_to welcome_path
    end
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
