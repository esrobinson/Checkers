require_relative 'board'
require_relative 'error'
require_relative 'human_player'

class Game

  def initialize(red_player, white_player)
    @red = red_player.playing_as(:r)
    @white = white_player.playing_as(:w)
    @board = Board.new
  end

  def play
    current_player, next_player = @red, @white
    until @board.lost?(current_player.color)
      begin
        puts @board
        @board.move(current_player.move, current_player.color)
      rescue InvalidMoveError => e
        puts e
        retry
      end
      current_player, next_player = next_player, current_player
    end
    puts "#{next_player} wins!"
  end

end


h1 = HumanPlayer.new("Red")
h2 = HumanPlayer.new("White")
g = Game.new(h1, h2)
g.play