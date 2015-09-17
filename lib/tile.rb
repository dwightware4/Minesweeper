class Tile
  attr_accessor :reveal, :explored
  attr_reader :bomb

  def initialize(bomb = false)
    @bomb = bomb
    @reveal = ' @ '
    @explored = false
  end
end
