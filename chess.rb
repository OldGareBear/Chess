require_relative 'pieces'


class Board

  attr_accessor :grid

  def self.blank_grid
    Array.new(8) { Array.new(8) }

  end

  def initialize
    @grid = self.class.blank_grid
    self.instantiate_pieces
  end

  def instantiate_pieces # can we make this class method?
    self.grid.each_with_index do |row, r_index|
      row.each_with_index do |col, c_index|
        position = [r_index, c_index]
        case position[1]
        when 0
          instantiate_back_row(position, :black)
        when 1
          self[position] = Pawn.new(:black, position, self)
        when 6
          self[position] = Pawn.new(:white, position, self)
        when 7
          instantiate_back_row(position, :white)
        end
      end
    end
  end

  def instantiate_back_row(position, color)
    case position[0]
    when 0, 7
      self[position] = Rook.new(color, position, self)
    when 1, 6
      self[position] = Knight.new(color, position, self)
    when 2, 5
      self[position] = Bishop.new(color, position, self)
    when 3
      self[position] = Queen.new(color, position, self)
    when 4
      self[position] = King.new(color, position, self)
    end
  end

  # # reference for having x, y be more intuititve
  def [](pos)#x, y
    x, y = pos
    self.grid[y][x]
  end

  def []=(pos, piece) # assign a piece or nil to a position
    x, y = pos
    @grid[y][x] = piece
  end

  def on_board?(position)
    position.all? { |coord| coord.between?(0, 7) }
  end

  def make_move(source, target)

    if self[source].moves.include?(target)
      self[target], self[source] = self[source], nil
      self[target].location = target
    else
      raise "Invalid Move" # use a ruby error?
    end

  end

  def render

    (0...8).each do |y|
      # print "#{y}  "

      (0...8).each do |x|

        current_square = self[[x, y]]
        print current_square ? current_square.to_s : "-"
        print "  "

      end
      print "\n"
    end

    nil
  end

end


class Game
end