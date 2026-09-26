class NicknamesController < ApplicationController

  # PATCH /nickname
  def update
    nickname = params[:nickname].to_s.strip.first(20)
    session[:nickname] = nickname.presence
    render partial: "nicknames/form", locals: { saved: true }
  end
end
