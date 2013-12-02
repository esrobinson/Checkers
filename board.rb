require_relative 'piece'

class Board
  attr_reader :pieces

  def initialize
    @pieces = starting_pieces
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

  def [](x, y)
    @pieces.find{ |piece| piece.position == [x, y] }
  end

  def empty?(x, y)
    [x, y].nil?
  end

  def to_s
    (0...8).map do |col|
      (0...8).map do |row|
        if empty?(row, 7-col)
          "*"
        else
          self[row, 7-col].to_s
        end
      end.join(" ")
    end.join("\n")
  end



end