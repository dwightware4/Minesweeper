require 'colorize'
require_relative 'tile.rb'

class Board
  attr_reader :grid, :size, :bombs, :possible_bombs, :rows

  def initialize(size, bombs)
    @grid = Array.new(size) { Array.new(size) }
    @size, @bombs, @possible_bombs, @unexplored = size, bombs, (size**2), ((size**2) - bombs)
    populate
  end

  def on_board?(pos)
    pos.all? { |coord| coord >= 0 && coord < (@size) }
  end

  def check(pos)
    self[pos].explored = true
    return if self[pos].reveal == '   '
    self[pos].reveal = '   '

    (-1..1).each do |x_offset|
      (-1..1).each do |y_offset|
        neighbor_pos = [pos[0] + x_offset, pos[1] + y_offset]
        # debugger
        next unless on_board?(neighbor_pos)
        next if neighbor_pos == pos || self[neighbor_pos].bomb

        bomb_count = find_bomb_count(neighbor_pos)
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

  def display
    header = (0...size).to_a.join(' ')
    puts "#{possible_bombs} POSSIBLE BOMBS LEFT!!!"
    puts "  #{header}".colorize(:red)
    grid.each_with_index do |row, i|
      display_row(row, i)
    end
    nil
  end

  def display_row(row, i)
    tiles = row.map(&:reveal).join(' ').colorize(:blue)
    puts "#{i.to_s.colorize(:red)} #{tiles}"
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

  def find_bomb_count(pos)
      total_bombs = 0

    (-1..1).each do |x_offset|
      (-1..1).each do |y_offset|
        x = x_offset + pos[0]
        y = y_offset + pos[1]
        total_bombs += 1 if pos_on_board?([x, y]) && self[[x, y]].bomb
      end
    end

    total_bombs
  end

  def possible_bomb_count
    counter = 0

    grid.each do |row|
      row.each do |tile|
        counter += 1 if tile.reveal == '   ' || tile.reveal.is_a?(Fixnum)
      end
    end
    @possible_bombs -= counter
  end

  def unexplored_count
    counter = 0

    grid.each do |row|
      row.each do |tile|
        counter += 1 if tile.reveal == ' @ ' || tile.reveal.is_a?(Fixnum) || tile.reveal == "   "
      end
    end
    @unexplored -= counter
  end

  def pos_on_board?(pos)
    pos.all? { |coord| (0...size).include?(coord) }
  end

  def rows
    @grid
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

  def random_pos
    [rand(size), rand(size)]
  end
end
