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

  def update_grid_successful?(row_index, column_index, player_symbol)
    update_grid(row_index, column_index, player_symbol)
  end

  private

  # The update_grid() method will update the grid with the player's move.
  def update_grid(row_index, column_index, player_symbol)
    if @grid[row_index][column_index] == ' '
      @grid[row_index][column_index] = player_symbol
    end
  end
end

class Player
  def initialize(player_symbol)
    @player_symbol = player_symbol
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

# Check grid's diagonals to see if they have three matching symbols
def check_diagonals(grid)
  return true if check_top_left_to_bottom_right_diagonal(grid)

  check_bottom_left_top_right_diagonal(grid)
end

# Check grid's rows, columns, and diagonals to see if a player has won
def check_grid_for_winner(grid)
  return true if check_rows_or_columns(grid, 'rows')
  return true if check_rows_or_columns(grid, 'columns')

  check_diagonals(grid)
end

def player_make_move(player, grid)
  player_move = player.make_move

  until grid.update_grid_successful?(player_move[0], player_move[1], player_move[2])
    puts 'Invalid input. Try again.'
    player_move = player.make_move
  end
end

def play_game
  player1 = Player.new('x')
  player2 = Player.new('o')
  grid = Grid.new
  turns_taken = 0
  winner_declared = false

  while turns_taken <= 9
    puts '----------------------------'
    puts "Player 1's turn\n"
    player_make_move(player1, grid)

    turns_taken += 1
    puts grid

    if turns_taken >= 5 && check_grid_for_winner(grid.grid)
      winner_declared = true
      break
    end

    break if turns_taken >= 9

    puts '----------------------------'
    puts "Player 2's turn\n"
    player_make_move(player2, grid)

    turns_taken += 1
    puts grid

    if turns_taken >= 5 && check_grid_for_winner(grid.grid)
      winner_declared = true
      break
    end
  end

  if winner_declared
    puts 'Player wins!'
  else
    puts 'Game is a draw!'
  end
end

play_game
