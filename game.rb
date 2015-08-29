require 'byebug'
require_relative 'board'

class Game
  attr_reader :board

  def initialize(size = 9, bombs = 4)
    @board = Board.new(size, bombs)
  end

  def get_pos
    puts "Choose Move"
    move = gets.chomp.split("").map { |el| el.to_i }

    unless board.pos_on_board?(move)
      get_pos
    end
    move
  end

  def single_move
    move = get_pos

    Kernel.abort("Game Over") if board.is_bomb?(move)

    bomb_count = board.find_bomb_count(move)
    if bomb_count > 0
      board[move].reveal = bomb_count
    else
      board.check(move)
      #board[move].reveal = "_"
    end
  end

  def play
    while true

      system("clear")
      board.possible_bomb_count
      board.display
      single_move

    end
  end

  def won?

  end


end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
