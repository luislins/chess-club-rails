module Admin
  # Área do administrador (só para o dono do site). HTTP Basic com senha via ENV.
  class BaseController < ApplicationController
    rate_limit to: 20, within: 1.minute, with: -> { head :too_many_requests }

    before_action :authenticate_admin!

    private

    def authenticate_admin!
      authenticate_or_request_with_http_basic("Chess Club Admin") do |user, password|
        ActiveSupport::SecurityUtils.secure_compare(user, admin_user) &
          ActiveSupport::SecurityUtils.secure_compare(password, admin_password)
      end
    end

    def admin_user = ENV.fetch("ADMIN_USER", "admin")

    def admin_password
      ENV["ADMIN_PASSWORD"].presence || (Rails.env.production? ? SecureRandom.hex(32) : "admin")
    end
  end
end
