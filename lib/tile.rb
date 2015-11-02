require './board'

class Tile
  attr_accessor :symbol, :state
  attr_reader :bomb

  def initialize(bomb = false)
    @bomb = bomb
    @state = :unknown
    @flagged = false
    @symbol = ' ▣ '
  end

  def update_symbol
    case state
    when :unknown
      @symbol = ' ▣ '
    when :empty
      @symbol = '   '
    when :flagged
      @symbol = ' X '
    end
  end
end
