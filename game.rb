require 'byebug'
require './board.rb'
require './display.rb'
require './cursorable'

class Game
  include Cursorable
  attr_reader :board

  def initialize(size = 9, bombs = size ** 2 / 8)
    @board = Board.new(size, bombs)
    @display = Display.new(@board)
  end

  def get_pos
    move = gets.chomp.split(",").map { |el| el.to_i }

    if board.pos_on_board?(move)
      return move
    else
      puts "Invalid Move!"
      puts "Try Again: "
      get_pos
    end
  end

  def single_move(move)
    Kernel.abort("GAME OVER!") if board.bomb?(move)

    bomb_count = board.find_bomb_count(move)
    if bomb_count > 0
      board[move].reveal = bomb_count
    else
      board.check(move)
    end
  end

  def play
    while true
      @display.render
      move = get_move
      single_move(move)
    end
  end
  
  def get_move
    result = nil
    until result
      @display.render
      result = @display.get_input
    end
  single_move(result)
  end

  def won?
    board.possible_bombs == board.bombs + 1
  end


end

if __FILE__ == $PROGRAM_NAME
  system("clear")
  puts "Welcome to Minesweeper!"
  puts
  puts "Select Difficulty: (Easy, Medium, or Hard)"
  
  difficulty = gets.chomp.downcase
  until difficulty == "easy" || difficulty == "medium" || difficulty == "hard"
    puts "Invalid Difficulty, Try Again!"
    difficulty = gets.chomp.downcase
  end

  case difficulty
  when "easy"
    game = Game.new(9, 10)
  when "medium"
    game = Game.new(16, 40)
  when "hard"
    game = Game.new(30, 99)
  end
  
  game.play
end
