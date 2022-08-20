class Board
  attr_reader :board

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

  def initialize(is_my_turn, player_symbol)
    @is_my_turn = is_my_turn
    @player_symbol = player_symbol
    @opponent_player = nil
  end

  # Get player input, validate, and return move selection to be made
  def make_move
    # Get player input
    print 'Enter row index: '
    row_index = gets.chomp.to_i
    print 'Enter column index: '
    column_index = gets.chomp.to_i
    # Validate through module methods
    # Return input as array of [row_index, column_index, player_symbol]
    [row_index, column_index, @player_symbol]
  end
end

def check_rows(board)
  winner_declared = true

  board.each_with_index do |row, row_index|
    winner_declared = true

    row.each_with_index do |_column, column_index|
      if board[row_index][column_index] == ' '
        winner_declared = false
        break
      end

      next if column_index.zero?

      winner_declared = false if board[row_index][column_index] != board[row_index][column_index - 1]
    end

    break if winner_declared
  end

  winner_declared
end

def check_board_for_winner(board)
  check_rows(board)

  # check_columns()
  # check_diagonals()
end
