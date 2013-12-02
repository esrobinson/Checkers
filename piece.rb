require_relative 'error'

class Piece
  PIECE_STRINGS = {
    :r => {
      false =>  "r", #man
      true => "R" #king
    },
    :w => {
      false =>  "w", #man
      true => "W" #king
    }
  }

  attr_reader :position, :color, :king

  def initialize(position, color, board)
    @position, @color, @board  = position, color, board
    @king = false
  end

  def directions
    return [[1, 1], [1, -1], [-1, 1], [-1, -1]] if @king
    return [[1, 1], [-1, 1]] if @color == :w
    return [[1, -1], [-1, -1]]
  end

  def move_diff(pos)
    [pos.first - @position.first, pos.last - @position.last]
  end

  def opposite_color
    @color == :r ? :w : :r
  end

  def perform_jump(pos)
    raise InvalidMoveError unless valid_jump?(pos)
    dir = move_diff(pos).map{ |x| x/2 }
    @board.jump(@position.first + dir.first, @position.last + dir.last)
    @position = pos
  end

  def perform_moves!(move_sequence)
    move_sequence.each do |move|
      if move_diff(move).first.abs > 1
        perform_jump(move)
      else
        raise InvalidMoveError if move_sequence.count > 1
        perform_slide(move)
      end
    end
  end

  def perform_slide(pos)
    raise InvalidMoveError unless valid_slide?(pos)
    @position = pos
  end

  def to_s
    PIECE_STRINGS[@color][@king]
  end

  def valid_jump?(pos)
    cur_x, cur_y = @position
    new_x, new_y = pos
    dir = move_diff(pos).map{ |x| x/2 }

    return false unless directions.include?(dir)
    return false unless new_x.between?(0, 7) && new_y.between?(0, 7)
    return false unless @board.empty?(pos.first, pos.last)
    @board.color?(cur_x + dir.first, cur_y + dir.last) == opposite_color
  end

  def valid_slide?(pos)
    cur_x, cur_y = @position
    new_x, new_y = pos
    return false unless directions.include?(move_diff(pos))
    return false unless new_x.between?(0, 7) && new_y.between?(0, 7)
    return false unless @board.empty?(pos.first, pos.last)
    true
  end

end