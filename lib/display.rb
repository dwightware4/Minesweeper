require 'colorize'

class Display
  attr_accessor :cursor_pos

  def initialize(board)
    @board, @cursor_pos = board, [4, 4]
  end

  def render_game
    print_messages
    render_board
  end

  def move_cursor(new_location)
    old_x, old_y = self.cursor_pos
    new_x, new_y = new_location
    new_pos = [old_x + new_x, old_y + new_y]
    self.cursor_pos = new_pos if board.on_board?(new_pos)
  end

  private
  attr_reader :board

  def rows
    board.grid.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def render_board
    rows.each { |row| puts row.join }
  end

  def print_messages
    system("clear")
    puts "Welcome to Minesweeper!".colorize(:blue)
    puts "Arrow keys to move, Space to explore, F to flag".colorize(:blue)
    puts "Remaining Bombs: #{board.remaining_bombs}".colorize(:red)
  end

  def build_row(row, i)
    row.map.with_index do |tile, j|
      color_options = colors_for(i, j)
      tile.update_symbol
      tile.symbol.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == cursor_pos
      bg = :blue
    elsif board[[i, j]].state == :unknown
      bg = :light_black
    elsif board[[i, j]].state == :flagged
      bg = :red
    else
      bg = :light_white
    end
    { background: bg, color: :black }
  end
end
