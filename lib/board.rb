require_relative 'tile.rb'
require 'colorize'
require 'byebug'

class Board
  attr_accessor :grid, :remaining_bombs, :unexplored_tiles

  def initialize(size, bombs)
    @size, @bombs, @remaining_bombs = size, bombs, bombs
    @grid = Array.new(size) { Array.new(size) }
    @unexplored_tiles = size**2
    populate
  end

  def explore(tile)
    self[tile].state == :unknown ? self[tile].state = :empty : return

    all_neighbors(tile).each do |neighbor|
      next if self[neighbor].bomb
      bombs = count_bombs(neighbor)
      bombs > 0 ? expose(self[neighbor], bombs) : explore(neighbor)
      next
    end
  end

  def expose(tile, bombs)
    tile.state = :exposed
    tile.symbol = " #{ bombs } "
  end

  def count_unexplored_tiles
    count = 0

    @grid.each do |row|
      row.each do |tile|
        count += 1 if tile.state == :unknown
      end
    end

    @unexplored_tiles = count
  end

  def count_bombs(pos)
    total_bombs = 0
    all_neighbors(pos).each { |tile| total_bombs += 1 if self[tile].bomb }
    total_bombs
  end

  def on_board?(pos)
    pos.all? { |coord| coord >= 0 && coord < (@size) }
  end

  def [](pos)
    x, y = pos[0], pos[1]
    grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    grid[x][y] = value
  end

  private
  attr_reader :bombs, :size

  def random_position!
    position = [rand(size), rand(size)]
    position = [rand(size), rand(size)] until self[position].nil?
    position
  end

  def populate
    bombs.times { place_tile(Tile.new(true)) }
    (size**2 - bombs).times { place_tile(Tile.new) }
  end

  def place_tile(tile)
    rando = random_position!
    self[rando] = tile
  end

  def all_neighbors(pos)
    neighbors = []

    (-1..1).each do |x_offset|
      (-1..1).each do |y_offset|
        x = x_offset + pos[0]
        y = y_offset + pos[1]
        neighbors << [x, y] if on_board?([x, y]) && [x, y] != pos
      end
    end

    neighbors
  end
end
