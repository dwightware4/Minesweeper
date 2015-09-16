require 'colorize'
require_relative 'cursorable.rb'

class Display
  attr_accessor :board, :cursor_pos
  include Cursorable

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
    nil
  end

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
    if [i, j] == @cursor_pos
      bg = :green
    elsif board[[i, j]].explored == true
      bg = :light_white
    else
      bg = :light_black
    end
    { background: bg, color: :black }
  end

  def render
    system("clear")
    puts "Welcome to Minesweeper!".colorize(:red)
    puts "Arrow keys or WASD to move, Space to select".colorize(:red)
    build_grid.each do |row|

      puts row.join
    end
    nil
  end

end
