class Board
  # The board is a 3x3 two dimensional array created when the object
  # is instantiated.
  def initialize
    @board = Array.new(3).map do
      Array.new(3, ' ')
    end
  end

  # The to_s() method is overridden to display the board as a grid of
  # three rows and three columns.
  def to_s
    board_to_print = @board.map do |row|
      row.join('|')
    end

    board_to_print.join("\n")
  end

  # The update_board() method will update the board with the player's move.
  def update_board(row_index, column_index, player_symbol)
    @board[row_index][column_index] = player_symbol
  end
end

class Player
  attr_accessor :is_my_turn, :player_symbol

  def initialize
    @is_my_turn = false
    @opponent_player = nil
    @player_symbol = ''
  end

  # Get player input, validate, and return move selection to be made
  def make_move
    # Get player input
    # Validate through module methods
    # Return input as array of [row_index, column_index, player_symbol]
  end
end
