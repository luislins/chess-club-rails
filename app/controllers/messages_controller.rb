class MessagesController < ApplicationController
  include RoomScoped

  rate_limit to: 10, within: 30.seconds, with: -> { render_rate_limited }

  # POST /rooms/:slug/messages
  def create
    message = @room.messages.build(body: params[:body].to_s.strip, nickname: current_nickname)
    if message.save
      # Quem enviou também recebe via broadcast (Turbo Stream), então não devolvemos nada.
      head :no_content
    else
      render_error(message.errors.full_messages.to_sentence)
    end
  end
end
