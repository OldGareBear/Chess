class Piece

  UP         = [0,  1]
  DOWN       = [0, -1]
  LEFT       = [-1, 0]
  RIGHT      = [1,  0]
  UP_LEFT    = [-1, 1]
  UP_RIGHT   = [1,  1]
  DOWN_LEFT  = [-1,-1]
  DOWN_RIGHT = [1, -1]

  attr_reader :color, :location, :board

  def initialize(color, location, board)
    @color = color
    @location = location
    @board = board
  end

  def inspect
    "I am a #{self.color} #{self.class} at #{self.location}"
  end

  def new_position(curr_position, delta)
    # method to get new location from current of piece
    x, y = curr_position
    dx, dy = delta
    new_pos = [x + dx, y - dy]
  end
end

class SlidingPiece < Piece

  def moves
    moves = []
    self.move_dirs.each do |dir|
      moves << one_direction(dir)
    end

    moves
  end

  def move_is_valid?(position)
    return false unless self.board.on_board?(position) && self.board[position].nil?
    # checks whether a position:
    # is occupied/unoccupied
    # is on the board
    true
  end

  def one_direction(direction)
    current_pos = self.location
    all_moves = []
    valid = true

    while valid
      current_pos = self.new_position(current_pos, direction)
      valid = move_is_valid?(new_pos)
      all_moves << new_pos if valid || self.board[current_position].color != self.color
    end

    all_moves
  end
end

class Queen < SlidingPiece

  def move_dirs
    [UP, DOWN, LEFT, RIGHT, UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT]
  end
end

class Rook < SlidingPiece

  def move_dirs
    [UP, DOWN, LEFT, RIGHT]
  end
end

class Bishop < SlidingPiece

  def move_dirs
    [UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT]
  end
end

class SteppingPiece < Piece

  def move
    all_moves = []
    possible_moves.each do |possible_move|
      new_position = self.new_position(self.location, possible_move)
      all_moves << new_position if move_is_valid?(new_position)
    end

    all_moves
  end

  def move_is_valid?(position)
    return false if self.board.on_board?(position) ||
      self.board[position].color == self.color

    # returns true if the position is on the board and empty/enemy
    true
  end

end

class King < SteppingPiece

  def possible_moves
    [UP, DOWN, LEFT, RIGHT, UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT]
  end
end

class Knight < SteppingPiece

  def possible_moves
    [[-2, -1],[-2,  1],[-1, -2],[-1,  2],
     [ 1, -2],[ 1,  2],[ 2, -1],[ 2,  1]]
  end
end

class Pawn < Piece

  def possible_moves
    if self.color == :black
      black_pawn_moves = [DOWN, DOWN_LEFT, DOWN_RIGHT]
      black_pawn_moves << [0, -2] if self.location[1] == 1 # black starts at the top
      black_pawn_moves
    else
      white_pawn_moves = [UP, UP_LEFT, UP_RIGHT]
      white_pawn_moves << [0, 2] if self.location[1] == 6
      white_pawn_moves
    end
  end

  def move_is_valid?(position)
  end

  def move
    all_moves = []

    diagonal_moves = self.possible_moves.select { |move| move[0] != 0 }
    straight_moves = self.possible_moves.select { |move| move[0] == 0 }

    diagonal_moves.each do |diagonal_move|
      new_pos = self.new_position(self.location, diagonal_move)
      next if self.board[new_pos].nil? || self.board[new_pos].color == self.color

      all_moves << new_pos
    end

    straight_moves.each do |straight_move|
      new_pos = self.new_position(self.location, straight_move)
      break unless self.board[new_pos].nil?
      all_moves << new_pos
    end

    all_moves
  end

end