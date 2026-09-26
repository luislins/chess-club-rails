module Admin
  class RoomsController < BaseController
    def index
      @rooms = Room.recent.includes(:messages)
      @stats = {
        open: Room.open.count,
        finished: Room.finished.count,
        stale: Room.stale.count,
        messages: Message.count,
        max_open: Room::MAX_OPEN_ROOMS,
        players_today: Player.today.count,
        games_today: Game.on(Arena.today).count,
        champions: Champion.count
      }
    end

    # POST /admin/close_day - (re)build yesterday's hall of fame entry now.
    def close_day
      day = Arena.today - 1
      ArenaCloseJob.perform_now(day)
      redirect_to admin_root_path, notice: "Dia #{I18n.l(day)} fechado."
    end

    def destroy
      room = Room.find_by!(slug: params[:slug])
      Turbo::StreamsChannel.broadcast_replace_to(room, target: "room", partial: "rooms/closed", locals: { room: room })
      room.destroy
      redirect_to admin_root_path, notice: "Sala #{room.name} removida."
    end

    # POST /admin/rooms/:slug/clear_chat
    def clear_chat
      room = Room.find_by!(slug: params[:slug])
      room.messages.delete_all
      Turbo::StreamsChannel.broadcast_update_to(room, target: "messages", html: "")
      redirect_to admin_root_path, notice: "Chat da sala #{room.name} limpo."
    end

    # POST /admin/rooms/cleanup
    def cleanup
      count = Room.stale.count
      RoomCleanupJob.perform_now
      redirect_to admin_root_path, notice: "#{count} sala(s) antiga(s) removida(s)."
    end
  end
end
