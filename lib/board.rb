require 'colorize'
require_relative 'tile.rb'
require 'byebug'

class Board
  attr_reader :grid, :size, :bombs, :possible_bombs

  def initialize(size, bombs)
    @grid = Array.new(size) { Array.new(size) }
    @size, @bombs = size, bombs
    populate
  end

  def check(pos)
    self[pos].explored = true
    return if self[pos].reveal == '   '
    self[pos].reveal = '   '

    (-1..1).each do |x_offset|
      (-1..1).each do |y_offset|
        neighbor_pos = [pos[0] + x_offset, pos[1] + y_offset]
        next unless on_board?(neighbor_pos)
        next if neighbor_pos == pos || self[neighbor_pos].bomb

        bomb_count = find_bomb_count(neighbor_pos)
        debugger
        if bomb_count > 0
          self[neighbor_pos].reveal = " #{bomb_count} "
          self[neighbor_pos].explored = true
        else
          check(neighbor_pos)
          next
        end
      end
    end
  end

  def populate
    bombs.times { place_tile(Tile.new(true)) }
    (size**2 - bombs).times { place_tile(Tile.new) }
  end

  def place_tile(tile)
    position = random_pos
    position = random_pos until self[position].nil?
    self[position] = tile
  end

  def bomb?(pos)
    self[pos].bomb
  end

  def pos_on_board?(pos)
    pos.all? { |coord| (0...size).include?(coord) }
  end

  def [](pos)
    x, y = pos[0], pos[1]
    grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    grid[x][y] = value
  end

  def find_bomb_count(pos)

    all_neighbors(pos).inject(0)  do |accum, neighbor|
      # debugger
      if self[neighbor].bomb
        accum + 1
      end
    end
    # total_bombs = 0
    #
    # all_neighbors(pos).each do |neighbor|
    #   total_bombs += 1 if self[neighbor].bomb
    # end
    #
    # total_bombs
  end

  private

  def all_neighbors(pos)
    neighbors = []

    (-1..1).each do |x_offset|
      (-1..1).each do |y_offset|
        x = x_offset + pos[0]
        y = y_offset + pos[1]
        neighbors << [x, y] if pos_on_board?([x, y])
      end
    end
    neighbors
  end

  def random_pos
    [rand(size), rand(size)]
  end

  def on_board?(pos)
    pos.all? { |coord| coord >= 0 && coord < (@size) }
  end
end
