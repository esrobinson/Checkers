def Piece
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

  def perform_slide(pos)
    raise InvalidMoveError unless valid_slide?(pos)
    @position = pos
  end

  def perform_jump(pos)
    raise InvalidMoveError unless valid_jump?(pos)
    dir = move_diff.map{ |x| x/2 }
    @board.jump([@position.first + dir.first, @position.last + dir.last])
    @position = pos
  end

  def valid_slide?(pos)
    cur_x, cur_y = @position
    new_x, new_y = pos
    return false unless directions.include?(move_diff(pos))
    return false unless new_x.between?(0..7) && new_y.between?(0..7)
    return false unless @board.empty?(pos)
    true
  end

  def valid_jump?(pos)
    cur_x, cur_y = @position
    new_x, new_y = pos
    dir = move_diff.map{ |x| x/2 }

    return false unless directions.include?(dir)
    return false unless new_x.between?(0..7) && new_y.between?(0..7)
    return false unless @board.empty?(pos)
    return false if @board.empty?([cur_x + dir.first, cur_y + dir.last])
    true
  end

  def move_diff(pos)
    [pos.first - @positon.first, pos.last - @positon.last]
  end





end