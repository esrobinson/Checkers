require_relative 'piece'
require_relative 'error'

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

  def capture(x, y)
    self[x, y] = nil
  end

  def color?(x, y)
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

  def move(start_pos, end_pos)
    self[end_pos.first, end_pos.last] = self[start_pos.first, start_pos.last]
    self[start_pos.first, start_pos.last] = nil
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
    COLUMN_HEADERS +
    (0...8).to_a.reverse.map do |row|
      "#{row.to_s} " +
      (0...8).map do |col|
        if empty?(col, row)
          "*"
        else
          self[col, row].to_s
        end
      end.join(" ")
    end.join("\n")
  end

  def won?
    #fix later
    false
  end


  protected
  attr_writer :board

end