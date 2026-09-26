class RoomsController < ApplicationController
  include RoomScoped

  skip_before_action :find_room, only: %i[index create]

  rate_limit to: 3, within: 10.minutes, only: :create, with: -> { redirect_to root_path, alert: "Calma! Você criou salas demais. Tente de novo mais tarde." }

  def index
    @rooms = Room.recent.limit(50)
    @room = Room.new
    @creation_error = Room.creation_error(player_token)
  end

  def create
    if (error = Room.creation_error(player_token))
      return redirect_to root_path, alert: error
    end

    @room = Room.new(room_params.merge(creator_token: player_token))
    if @room.save
      redirect_to @room, notice: "Sala criada! Sente-se em uma cadeira para jogar."
    else
      redirect_to root_path, alert: @room.errors.full_messages.to_sentence
    end
  end

  def show
    @messages = @room.messages.order(:id).last(Room::MAX_MESSAGES)
  end

  # GET /rooms/:slug/state?from=e2
  # Estado personalizado para quem está vendo (tabuleiro clicável, cadeiras, etc).
  # Chamado pelo htmx: no clique de uma peça e sempre que o servidor faz o broadcast.
  def state
    selected = params[:from].to_s
    selected = nil unless selected.match?(/\A[a-h][1-8]\z/) && @room.own_piece?(@room.color_of(player_token), selected)
    render_state(selected: selected)
  end

  def destroy
    return render_error("Só quem criou a sala pode fechá-la.", status: :forbidden) unless @room.creator?(player_token)

    Turbo::StreamsChannel.broadcast_replace_to(@room, target: "room", partial: "rooms/closed", locals: { room: @room })
    @room.destroy
    response.set_header("HX-Redirect", root_path)
    head :ok
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end
end
