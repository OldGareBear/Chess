require_relative 'board'
require_relative 'player'

class Game

  # COLORS = [:black, :white]

  attr_accessor :board, :cursor, :turn, :grabbed

  def initialize
    @board = Board.new
    @cursor = board.cursor
    @grabbed = []
    @player1 = Player.new(:white)
    @player2 = Player.new(:black)
    @turn = :white
  end

  def play
    until board.checkmate?(:black) || board.checkmate?(:white)
      board.render

      begin
        take_turn(get_chr)

      rescue WrongPieceError
        puts "please choose a new piece"
        grabbed.clear
        retry
      # ensure
      end

      #process_action(get_chr)

      next_turn
    end
  end

  def get_chr
    begin
      system("stty raw -echo")
      str = STDIN.getc
    ensure
      system("stty -raw echo")
    end
  end

  def take_turn(chr)
    case chr.downcase
    when 'w'
      cursor.up
    when 'a'
      cursor.left
    when 's'
      cursor.down
    when 'd'
      cursor.right
    when ' '
      # selected_piece = board[board.cursor_square]
      # raise "Wrong color piece!" if selected_piece.color != color
      grabbed << board.cursor_square

      selected_piece = board[grabbed[0]]
      p "#{turn} turn"
      p "#{grabbed} "
      p "#{selected_piece.color} selected piece's color"
      if selected_piece.color != self.turn
        raise WrongPieceError.new "Wrong color piece!"
      end

      if grabbed.length == 2

        board.make_move(grabbed[0], grabbed[1])

        grabbed.clear
      end

    when 'q'
      exit
    end
  end

  def next_turn
    @turn = (turn == :white ? :black : :white)
  end

  def in_check_message
  end

  def checkmate_message
  end




end

class WrongPieceError < StandardError
end