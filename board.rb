require_relative 'piece'
require_relative 'error'

class Board
  attr_reader :pieces

  def initialize
    @pieces = starting_pieces
  end

  def [](x, y)
    @pieces.find{ |piece| piece.position == [x, y] }
  end

  def color?(x, y)
    return nil if empty?(x, y)
    self[x, y].color
  end

  def dup
    dup_board = Board.new
    dup_board.pieces = @pieces.map{ |piece| piece.dup(dup_board) }
    dup_board
  end

  def empty?(x, y)
    self[x, y].nil?
  end

  def capture(x, y)
    @pieces.delete(self[x, y])
  end

  def starting_pieces
    pieces = []
    24.times do |i|
      pieces << Piece.new([i % 8, i / 8], :w, self) if (i % 8 + i/8).even?
    end

    24.times do |i|
      if (i % 8 + i/8).even?
        pieces << Piece.new([(63 - i) % 8, (63 - i) / 8], :r, self)
      end
    end

    pieces
  end

  def to_s
    (0...8).to_a.reverse.map do |col|
      (0...8).map do |row|
        if empty?(row, col)
          "*"
        else
          self[row, col].to_s
        end
      end.join(" ")
    end.join("\n")
  end

  protected
  attr_writer :pieces

end