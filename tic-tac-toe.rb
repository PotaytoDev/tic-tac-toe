class Grid
  attr_reader :grid

  # The grid is a 3x3 two dimensional array created when the object
  # is instantiated.
  def initialize
    @grid = Array.new(3).map do
      Array.new(3, ' ')
    end
  end

  # The to_s() method is overridden to display the grid as three rows
  # and three columns.
  def to_s
    grid_to_print = @grid.map do |row|
      row.join('|')
    end

    grid_to_print.join("\n")
  end

  # The update_grid() method will update the grid with the player's move.
  def update_grid(row_index, column_index, player_symbol)
    @grid[row_index][column_index] = player_symbol
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

def check_rows(grid)
  winner_declared = true

  grid.each_with_index do |row, row_index|
    winner_declared = true

    row.each_with_index do |_column, column_index|
      if grid[row_index][column_index] == ' '
        winner_declared = false
        break
      end

      next if column_index.zero?

      if grid[row_index][column_index] != grid[row_index][column_index - 1]
        winner_declared = false
      end
    end

    break if winner_declared
  end

  winner_declared
end

def check_grid_for_winner(grid)
  check_rows(grid)

  # check_columns()
  # check_diagonals()
end
