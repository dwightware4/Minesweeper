require_relative 'board.rb'
require_relative 'display.rb'
require_relative 'cursorable'

class Game
  include Cursorable

  def initialize(size = 9, bombs = size ** 2 / 8)
    @board = Board.new(size, bombs)
    @display = Display.new(board)
    @bombs = bombs
  end

  def play
    until won?
      display.render
      play_turn
    end
  end

  private
  attr_reader :board, :display

  def play_turn
    move = get_move
    if move[:action] == :explore
      single_move(move[:location]) unless board[move[:location]].reveal == " X "
    elsif move[:action] == :flag
      if board[move[:location]].reveal = " @ "
        board[move[:location]].reveal = " X "
      else
        board[move[:location]].reveal = " @ "
      end
    end
  end

  def get_move
    result = nil
    until result
      display.render
      result = get_input
    end
  result
  end

  def single_move(move)
    Kernel.abort("GAME OVER!") if board.bomb?(move)

    bomb_count = board.find_bomb_count(move)

    if bomb_count > 0
      board[move].explored = true
      board[move].reveal = " #{bomb_count} "
    else
      board.check(move)
    end
  end

  def won?
    board.possible_bombs == board.bombs + 1
  end
end

if __FILE__ == $PROGRAM_NAME
  system("clear")
  puts "Welcome to Minesweeper!".colorize(:red)
  puts
  puts "Select Difficulty: (Easy, Medium, or Hard)".colorize(:red)

  difficulty = 'easy'#gets.chomp.downcase
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
