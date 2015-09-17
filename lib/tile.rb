class Tile
  attr_reader :bomb
  attr_accessor :reveal, :explored

  def initialize(bomb = false)
    @bomb = bomb
    @reveal = ' @ '
    @explored = false
  end

end
