# Shared by the controllers nested under /rooms/:room_slug.
module RoomScoped
  extend ActiveSupport::Concern

  included do
    before_action :find_room
  end

  private

  def find_room
    @room = Room.find_by!(slug: params[:room_slug] || params[:slug])
  end

  # Default response for htmx actions: the board (target) plus out-of-band panels.
  def render_state(selected: nil, promotion: nil, status: :ok)
    render partial: "rooms/state", locals: { room: @room, selected: selected, promotion: promotion }, status: status
  end
end
