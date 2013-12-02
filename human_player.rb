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
    positions.map{ |pos| pos.split(',').map(&:to_i)}
  end

end