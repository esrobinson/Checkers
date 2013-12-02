require_relative 'piece'
require_relative 'error'
require 'colorize'

class Board
  attr_reader :board

  def initialize
    @board = Array.new(8) { Array.new(8) }
    starting_pieces
  end

  def [](x, y)
    @board[x][y]
  end

  def []= (x, y, value)
    @board[x][y] = value
  end

  def can_jump?(color)
    pieces_of(color).any?(&:can_jump?)
  end

  def capture(x, y)
    self[x, y] = nil
  end

  def color(x, y)
    return nil if empty?(x, y)
    self[x, y].color
  end

  def dup
    dup_board = Board.new
    dup_board.board = @board.map do |row|
      row.map do |square|
        if square.nil?
          nil
        else
          square.dup(dup_board)
        end
      end
    end
    dup_board
  end

  def empty?(x, y)
    self[x, y].nil?
  end

  def is_jump?(move_sequence)
    (move_sequence[0].first - move_sequence[1].first).abs == 2
  end

  def lost?(color)
    pieces_of(color).none?(&:can_move?)
  end

  def move(move_sequence, player_color)
    validate_move(move_sequence, player_color)
    start_pos = move_sequence.shift
    self[start_pos.first, start_pos.last].perform_moves(move_sequence)
  end

  def move_piece(start_pos, end_pos)
    self[end_pos.first, end_pos.last] = self[start_pos.first, start_pos.last]
    self[start_pos.first, start_pos.last] = nil
  end

  def pieces_of(color)
    @board.flatten.select do |square|
      if square.nil?
        false
      else
        square.color == color
      end
    end
  end

  def starting_pieces
    24.times do |i|
      if (i % 8 + i/8).even?
      @board[i % 8][i / 8] =
              Piece.new([i % 8, i / 8], :w, self)
      end
    end

    24.times do |i|
      if (i % 8 + i/8).even?
        @board[(63 - i) % 8][(63 - i) / 8] =
              Piece.new([(63 - i) % 8, (63 - i) / 8], :r, self)
      end
    end
  end

  COLUMN_HEADERS = "  0 1 2 3 4 5 6 7\n"
  def to_s
    next_color, last_color = nil, :green
    COLUMN_HEADERS +
    (0...8).to_a.reverse.map do |row|
      next_color, last_color = last_color, next_color
      "#{row.to_s} " +
      (0...8).map do |col|
        next_color, last_color = last_color, next_color
        if empty?(col, row)
          "  ".colorize(background: next_color)
        else
          self[col, row].to_s + " ".on_green
        end
      end.join("")
    end.join("\n")
  end

  def validate_move(move_sequence, player_color)
    start_pos = move_sequence.first
    unless color(start_pos.first, start_pos.last) == player_color
      raise InvalidMoveError
    end
    if can_jump?(player_color) and !is_jump?(move_sequence)
      raise InvalidMoveError
    end
  end

  protected
  attr_writer :board

end