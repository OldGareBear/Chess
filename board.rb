require_relative 'pieces'
require_relative 'cursor'

class Board
  attr_reader :cursor

  def self.blank_grid
    Array.new(8) { Array.new(8) }
  end

  def initialize
    @grid = self.class.blank_grid
    instantiate_pieces
    @cursor = Cursor.new
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

  def make_move!(source, target)
    #
    # if self[source].nil?
    #   raise "You can't move an empty square, ya dingus."
    # elsif self[source].moves_without_check.include?(target)
    self[target], self[source] = self[source], nil
    self[target].location = target
    # else
    #   raise "Invalid Move" # use a ruby error?
    # end

  end

  def in_check?(color)
    enemies = enemies(color)
    king_loc = find_king(color)
    enemy_moves = []

    enemies.each do |enemy|
      enemy_moves += enemy.moves_without_check
    end

    enemy_moves.include?(king_loc)
  end

  def checkmate?(color)
    return false unless self.in_check?(color)

    own_pieces = own_pieces(color)
    own_pieces.all? { |piece| piece.moves.empty? }
  end

  def render
    clear_screen

    puts "   0  1  2  3  4  5  6  7"
    (0...8).each do |y|
      print "#{y}  "
      (0...8).each do |x|
        current_square = self[[x, y]]

        if [x, y] == cursor_square
          print current_square ? gray(current_square.to_s) : gray("-")
        else
          print current_square ? current_square.to_s : "-"
        end

        print "  "

      end
      print "\n"
    end

    nil
  end

  def cursor_square
    [cursor.row, cursor.col]
  end

  def gray(str)
    str = str.gsub(/\033\[\d+m/, "")
    "\033[37m#{str}\033[0m"
  end

  def clear_screen
    system("clear")
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

    get_all_pieces.each do |piece|
      mapping[piece.location] = [piece.class, piece.color]
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
    pieces = [Rook, Knight, Bishop, King, Queen, Bishop, Knight, Rook]

    pieces.each_with_index do |piece, index|
      self[position] = piece.new(color, position, self) if index == position[0]
    end
  end

  def get_all_pieces
    grid.flatten.compact
  end

  def find_king(color)
    own_pieces(color).each { |piece| return piece.location if piece.class == King }
  end

  def own_pieces(color)
    get_all_pieces.select { |piece| piece.color == color }
  end

  def enemies(color)
    get_all_pieces.select { |piece| piece.color != color }
  end


end