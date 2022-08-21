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

# Check if a grid cell is empty
def empty_grid_cell?(grid, first_index, second_index, direction_to_check)
  case direction_to_check
  when 'rows'
    row_index = first_index
    column_index = second_index
  when 'columns'
    row_index = second_index
    column_index = first_index
  end

  grid[row_index][column_index] == ' '
end

# Check whether a grid cell matches the previous grid cell in a given direction
def grid_cells_match?(grid, first_index, second_index, direction_to_check)
  case direction_to_check
  when 'rows'
    row_index = first_index
    column_index = second_index
    grid[row_index][column_index] == grid[row_index][column_index - 1]

  when 'columns'
    row_index = second_index
    column_index = first_index
    grid[row_index][column_index] == grid[row_index - 1][column_index]
  end
end

# Check rows or columns to determine if any of them have three matching symbols
def check_rows_or_columns(grid, direction_to_check = 'rows')
  winner_declared = true

  grid.each_with_index do |row, first_index|
    winner_declared = true

    row.each_with_index do |_column, second_index|
      if empty_grid_cell?(grid, first_index, second_index, direction_to_check)
        winner_declared = false
        break
      end

      next if second_index.zero?

      unless grid_cells_match?(grid, first_index, second_index, direction_to_check)
        winner_declared = false
      end
    end

    break if winner_declared
  end

  winner_declared
end

def check_top_left_to_bottom_right_diagonal(grid)
  row_index = 0
  column_index = 0

  return false if grid[row_index][column_index] == ' '

  winner_declared = true

  2.times do
    if grid[row_index][column_index] != grid[row_index + 1][column_index + 1]
      winner_declared = false
    end

    row_index += 1
    column_index += 1
  end

  winner_declared
end

def check_bottom_left_top_right_diagonal(grid)
  row_index = 0
  column_index = grid.length - 1

  return false if grid[row_index][column_index] == ' '

  winner_declared = true

  2.times do
    if grid[row_index][column_index] != grid[row_index + 1][column_index - 1]
      winner_declared = false
    end

    row_index += 1
    column_index -= 1
  end

  winner_declared
end

def check_diagonals(grid)
  return true if check_top_left_to_bottom_right_diagonal(grid)

  check_bottom_left_top_right_diagonal(grid)
end

def check_grid_for_winner(grid)
  if check_rows_or_columns(grid, 'rows')
    puts 'Row matches!'
    return
  end
  if check_rows_or_columns(grid, 'columns')
    puts 'Column matches!'
    return
  end
  if check_diagonals(grid)
    puts 'Diagonal matches!'
    return
  end

  puts 'No winner!'
end
