# Compartilhado pelos controllers aninhados em /rooms/:room_slug.
module RoomScoped
  extend ActiveSupport::Concern

  included do
    before_action :find_room
  end

  private

  def find_room
    @room = Room.find_by!(slug: params[:room_slug] || params[:slug])
  end

  # Resposta padrão das ações htmx: tabuleiro (alvo) + painéis fora-de-banda.
  def render_state(selected: nil, promotion: nil, status: :ok)
    render partial: "rooms/state", locals: { room: @room, selected: selected, promotion: promotion }, status: status
  end
end
