# coding: utf-8
require_relative 'error'
require 'colorize'


class Piece
  PIECE_STRINGS = {
    :r => {
      false =>  "\u25CF".red.on_green, #man
      true => "\u265A".red.on_green #king
    },
    :w => {
      false =>  "\u25CF".white.on_green, #man
      true => "\u265A".white.on_green #king
    }
  }

  attr_reader :position, :color, :king, :board

  def initialize(position, color, board, king = false)
    @position, @color, @board  = position, color, board
    @king = king
  end

  def can_move?
   can_slide? || can_jump?
  end

  def can_jump?
    possible_moves = []
    directions.each do |dir|
      possible_moves <<
        [2 * dir.first + @position.first, 2 * dir.last + @position.last]
    end
    possible_moves.any?{ |pos| valid_jump?(pos) }
  end

  def dup(board)
    Piece.new(@position, @color, board, @king)
  end


  def perform_moves(move_sequence)
    raise InvalidMoveError unless valid_move_sequence?(move_sequence)
    perform_moves!(move_sequence)
  end

  def to_s
    PIECE_STRINGS[@color][@king]
  end

  protected

  def perform_moves!(move_sequence)
    move_sequence.each do |move|
      if move_diff(move).first.abs > 1
        perform_jump(move)
      else
        raise InvalidMoveError if move_sequence.count > 1
        perform_slide(move)
      end
    end
    maybe_promote
  end

  private

  def can_slide?
    possible_moves = []
    directions.each do |dir|
      possible_moves <<
        [dir.first + @position.first, dir.last + @position.last]
    end
    possible_moves.any?{ |pos| valid_slide?(pos) }
  end

  def captured_piece(pos)
    dir = move_diff(pos).map{ |x| x/2 }
    [dir.first + @position.first, dir.last + @position.last]
  end


  def directions
    return [[1, 1], [1, -1], [-1, 1], [-1, -1]] if @king
    return [[1, 1], [-1, 1]] if @color == :w
    return [[1, -1], [-1, -1]]
  end

  def maybe_promote
    back_row = color == :w ? 7 : 0
    @king = true if @position.last == back_row
  end

  def move_diff(pos)
    [pos.first - @position.first, pos.last - @position.last]
  end

  def on_board?(pos)
    x, y = pos
    x.between?(0, 7) && y.between?(0, 7)
  end

  def opposite_color
    @color == :r ? :w : :r
  end

  def perform_jump(pos)
    raise InvalidMoveError unless valid_jump?(pos)
    captured = captured_piece(pos)
    @board.capture(captured.first, captured.last)
    @board.move_piece(@position, pos)
    @position = pos
  end

  def perform_slide(pos)
    raise InvalidMoveError unless valid_slide?(pos)
    @board.move_piece(@position, pos)
    @position = pos
  end

  def valid_jump?(pos)
    new_x, new_y = pos
    cur_x, cur_y = @position
    cap_x, cap_y = captured_piece(pos)
    dir = move_diff(captured_piece(pos))

    return false unless directions.include?(dir)
    return false unless on_board?(pos)
    return false unless @board.empty?(new_x, new_y)
    @board.color(cap_x, cap_y) == opposite_color
  end

  def valid_move_sequence?(move_sequence)
    dup_board = @board.dup
    begin
      dup_board[@position.first, @position.last].perform_moves!(move_sequence)
    rescue InvalidMoveError => e
      return false
    else
      return true
    end
  end

  def valid_slide?(pos)
    new_x, new_y = pos

    return false if @board.can_jump?(@color)
    return false unless directions.include?(move_diff(pos))
    return false unless on_board?(pos)
    return false unless @board.empty?(new_x, new_y)
    true
  end

end