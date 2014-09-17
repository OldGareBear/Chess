# require 'debugger'
require_relative 'pieces'

class Board

  def self.blank_grid
    Array.new(8) { Array.new(8) }
  end

  def initialize
    @grid = self.class.blank_grid
    instantiate_pieces
  end

  # # reference for having x, y be more intuititve
  def [](pos)#x, y
    x, y = pos
    grid[y][x]
  end

  def []=(pos, piece) # assign a piece or nil to a position
    x, y = pos
    grid[y][x] = piece
  end

  def on_board?(position)
    position.all? { |coord| coord.between?(0, 7) }
  end

  def make_move(source, target)

    if self[source].nil?
      raise "You can't move an empty square, ya dingus."
    elsif self[source].moves.include?(target)
      self[target], self[source] = self[source], nil
      self[target].location = target
    else
      raise "Invalid Move" # use a ruby error?
    end

  end

  def in_check?(color)
    enemy_positions = enemy_positions(color)
    king_loc = find_king(color)
    enemy_moves = []

    enemy_positions.each do |enemy|
      enemy_moves += self[enemy].moves
    end

    enemy_moves.include?(king_loc)
  end

  def render
    (0...8).each do |y|
      (0...8).each do |x|

        current_square = self[[x, y]]
        print current_square ? current_square.to_s : "-"
        print "  "

      end
      print "\n"
    end

    nil
  end

  def deep_dup
    duped = Board.new
    mapped = self.map_board

    duped.each_square do |square|
      if mapped.has_key?(square)
        piece_type = mapped[square][0]
        color = mapped[square][1]

        duped[square] = piece_type.new(color, square, duped)
      else
        duped[square] = nil
      end
    end

    duped
  end

  def map_board
    mapping = Hash.new

    each_square do |square|
      piece = self[square]

      next if piece.nil?

      mapping[square] = [piece.class, piece.color]
    end

    mapping
  end

  protected

  def each_square(&prc)
    (0..7).each do |row|
      (0..7).each do |col|
        prc.call([row, col])
      end
    end
  end

  private

  attr_reader :grid

  def instantiate_pieces # can we make this class method?
    grid.each_with_index do |row, r_index|
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

  def find_king(color)
    loc = nil
    each_square do |square|
      loc = square if self[square].class == King && self[square].color == color
    end

    loc
  end

  def enemy_positions(color)
    positions = []

    each_square do |square|
      positions << square if !self[square].nil? && self[square].color != color
    end

    positions
  end

end


class Game
end