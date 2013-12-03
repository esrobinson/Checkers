require_relative 'error'

class HumanPlayer
  attr_reader :name, :color

  def initialize(name)
    @name = name
  end

  def playing_as(color)
    @color = color
    self
  end

  def move
    puts "Make a move (FORMAT: 0, 0; 1, 1; 0, 2;)"
    move = gets.chomp
    parse_move(move)
  end

  def parse_move(move)
    positions = move.split(';')
    begin
      parsed = positions.map do |pos|
        pos.split(',').map { |coord| Integer(coord) - 1}
      end
    rescue ArgumentError => e
      raise InvalidMoveError
    end
    raise InvalidMoveError if positions.count < 2
    parsed
  end

end