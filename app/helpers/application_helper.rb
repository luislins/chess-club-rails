module ApplicationHelper
  # Always use the filled ("black") glyphs and color them with CSS.
  PIECE_GLYPHS = {
    "k" => "♚", "q" => "♛", "r" => "♜", "b" => "♝", "n" => "♞", "p" => "♟"
  }.freeze

  def piece_glyph(piece)
    return "" if piece.blank?
    PIECE_GLYPHS[piece.downcase]
  end

  def piece_color_class(piece)
    return nil if piece.blank?
    piece == piece.upcase ? "white-piece" : "black-piece"
  end

  def color_name(color)
    color.to_s == "white" ? "Brancas" : "Pretas"
  end
end
