class MessagesController < ApplicationController
  include RoomScoped

  rate_limit to: 10, within: 30.seconds, with: -> { render_rate_limited }

  # POST /rooms/:slug/messages
  def create
    message = @room.messages.build(body: params[:body].to_s.strip, nickname: current_nickname)
    if message.save
      # The sender gets the message through the broadcast (Turbo Stream) like everyone else.
      head :no_content
    else
      render_error(message.errors.full_messages.to_sentence)
    end
  end
end
