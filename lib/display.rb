require 'colorize'
require_relative 'board.rb'

class Display
  attr_accessor :cursor_pos, :remaining_bombs
  attr_reader :board

  def initialize(board, bombs)
    @board = board
    @cursor_pos = [0, 0]
    @remaining_bombs = bombs
  end

  def render
    system("clear")
    puts "Welcome to Minesweeper!".colorize(:blue)
    puts "Arrow keys to move, Space to select".colorize(:blue)
    puts "Bombs: bombs".colorize(:red)
    build_grid.each do |row|
    puts row.join
    end
  end

  private

  def build_grid
    board.grid.map.with_index do |row, i|
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
