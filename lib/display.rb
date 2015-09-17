require 'colorize'

class Display
  attr_accessor :cursor_pos
  attr_reader :board

  def initialize(board)
    @board, @cursor_pos = board, [0, 0]
  end

  def render
    system("clear")
    puts "Welcome to Minesweeper!".colorize(:blue)
    puts "Arrow keys to move, Space to select".colorize(:blue)
    puts "Bombs: #{board.possible_bomb_count}".colorize(:red)
    build_grid.each do |row|
    puts row.join
    end
  end

  private

  def build_grid
    board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |tile, j|
      color_options = colors_for(i, j)
      tile.reveal.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == cursor_pos
      bg = :green
    elsif board[[i, j]].explored == true
      bg = :light_white
    else
      bg = :light_black
    end
    { background: bg, color: :black }
  end
end
