module ArenaHelper
  CROWN = "👑"

  # Player name with the crown when that token leads today's ranking.
  def crowned_name(name, token)
    return name if name.blank?
    arena_leader && arena_leader.token == token ? "#{name} #{CROWN}" : name
  end

  def theme_badge(theme)
    return if theme.classic?
    tag.span(theme.name, class: "theme-badge")
  end

  # "1 partida", "3 partidas"
  def count_pt(n, singular, plural = "#{singular}s")
    "#{n} #{n == 1 ? singular : plural}"
  end

  # Text ready to paste in WhatsApp for the day recap.
  def share_text(recap)
    lines = [ "♞ Chess Club · #{I18n.l(recap.day, format: :short)}" ]
    theme = Arena::Theme.for(recap.day)
    lines << "🎲 #{theme.name}" unless theme.classic?
    lines << (recap.champion_name ? "🏆 Campeão: #{recap.champion_name} (#{recap.champion_points} pts)" : "🏆 Ninguém pontuou")
    lines << "🔮 Melhor palpiteiro: #{recap.best_predictor_name} (#{count_pt(recap.best_predictor_correct, 'acerto')})" if recap.best_predictor_name
    lines << "⚡ Mate mais rápido: #{recap.fastest_mate_winner} em #{recap.fastest_mate_moves} lances" if recap.fastest_mate_winner
    lines << "#{count_pt(recap.games_count, 'partida')} · #{count_pt(recap.players_count, 'jogador', 'jogadores')}"
    lines << day_url(recap.day.iso8601)
    lines.join("\n")
  end
end
