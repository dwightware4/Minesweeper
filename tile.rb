class Tile
  attr_reader :bomb
  attr_accessor :reveal

  def initialize(bomb = false)
    @bomb = bomb
    @reveal = "*"
  end
end
