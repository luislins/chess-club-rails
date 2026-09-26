class NicknamesController < ApplicationController
  rate_limit to: 5, within: 1.minute, with: -> { render_rate_limited }

  # PATCH /nickname
  def update
    nickname = params[:nickname].to_s.strip.first(20)
    session[:nickname] = nickname.presence
    render partial: "nicknames/form", locals: { saved: true }
  end
end
