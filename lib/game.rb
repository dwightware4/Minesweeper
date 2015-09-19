load 'board.rb'
load 'display.rb'
require_relative 'cursorable'

class Game
  include Cursorable

  def initialize(size = 9, bombs = size ** 2 / 8)
    @board = Board.new(size, bombs)
    @display = Display.new(board)
  end

  def play
    until won?
      display.render_game
      perform_action
      board.count_unexplored_tiles
    end
    game_over_messages(:win)
  end

  private
  attr_reader :board, :display

  def perform_action
    move = get_move
    explore_tile(move[:location]) if move[:action] == :explore
    flag_tile(move[:location]) if move[:action] == :flag
  end

  def game_over_messages(outcome)
    if outcome == :win
      puts "Congratulations, you've won!"
    elsif outcome == :loss
      puts "You Lost!"
    end
    puts "Play again? (y / n)"
    response = gets.chomp.downcase
    if response == "y"
      Kernel.exec("ruby game.rb")
    elsif response == "n"
      Kernel.abort("Goodbye")
    else
      puts "Invalid response; please enter 'y' or 'n'."
    end
  end

  def flag_tile(tile)
    if board[tile].state == :unknown
      board[tile].state = :flagged
      board.remaining_bombs -= 1
    elsif board[tile].state == :flagged
      board[tile].state = :unknown
      board.remaining_bombs += 1
    end
  end

  def explore_tile(tile)
    single_move(tile) if board[tile].state == :unknown
  end

  def get_move
    result = nil
    until result
      display.render_game
      result = get_input
    end
  result
  end

  def single_move(move)
    game_over_messages(:loss) if board[move].bomb
    bomb_count = board.count_bombs(move)

    if bomb_count > 0
      board[move].state = :bomb_neighbor
      board[move].symbol = " #{bomb_count} "
    else
      board.check(move)
    end
  end

  def won?
    board.unexplored_tiles < 1
  end
end

if __FILE__ == $PROGRAM_NAME
  system("clear")
  puts "Welcome to Minesweeper!".colorize(:red)
  puts
  puts "Select Difficulty: (Easy, Medium, or Hard)".colorize(:red)

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
