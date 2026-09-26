class FaqController < ApplicationController
  skip_before_action :require_player

  def show
    @theme = Arena::Theme.for
  end
end
