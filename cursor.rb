class Cursor
  SIZE = 8

  attr_reader :row, :col

  def initialize
    @row = 0
    @col = 0
  end

  def left
    @row = (row - 1) % SIZE
  end

  def right
    @row = (row + 1) % SIZE
  end

  def up
    @col = (col - 1) % SIZE
  end

  def down
    @col = (col + 1) % SIZE
  end

end