require "io/console"

module Cursorable
  KEYMAP = {
    " " => :space,
    "f" => :flag,
    "\e[A" => :up,
    "\e[B" => :down,
    "\e[C" => :right,
    "\e[D" => :left,
    "\u0003" => :ctrl_c,
  }

  MOVES = {
    left: [0, -1],
    right: [0, 1],
    up: [-1, 0],
    down: [1, 0]
  }

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end

  private

  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def handle_key(key)
    case key
    when :ctrl_c
      exit
    when :space
      {location: display.cursor_pos, action: :explore}
    when :left, :right, :up, :down
      display.move_cursor(MOVES[key])
      nil
    when :flag
      {location: display.cursor_pos, action: :flag}
    end
  end
end
