class ApplicationController < ActionController::Base
  # Só browsers modernos (suporte a webp, web push, badges, import maps, CSS nesting e :has).
  allow_browser versions: :modern

  before_action :ensure_player_token

  helper_method :player_token, :current_nickname, :htmx_request?

  private

  # Sem autenticação: cada navegador ganha um token aleatório na sessão
  # (cookie assinado/cifrado). É a "identidade" do jogador.
  def ensure_player_token
    session[:player_token] ||= SecureRandom.hex(16)
  end

  def player_token = session[:player_token]

  def current_nickname
    session[:nickname].presence || "Anônimo-#{player_token.to_s.first(4)}"
  end

  def htmx_request? = request.headers["HX-Request"].present?

  # Erro mostrado via swap out-of-band do htmx no #flash.
  def render_error(message, status: :unprocessable_entity)
    render partial: "shared/flash", locals: { error: message }, status: status
  end

  def render_rate_limited
    render_error("Calma! Muitas requisições. Tente de novo em instantes.", status: :too_many_requests)
  end
end
