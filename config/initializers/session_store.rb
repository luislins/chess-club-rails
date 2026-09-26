# Keep the anonymous identity (player token + nickname) across browser restarts.
Rails.application.config.session_store :cookie_store, key: "_chess_club_session", expire_after: 1.year
