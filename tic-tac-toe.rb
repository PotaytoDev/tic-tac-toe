class Grid
  attr_reader :grid

  # The grid is a 3x3 two dimensional array created when the object
  # is instantiated
  def initialize
    @grid = Array.new(3).map do
      Array.new(3, ' ')
    end
  end

  # The to_s() method is overridden to display the grid as four rows
  # and four columns. With letters on the first row and numbers on the first
  # column, indicating the possible move selections a player can make
  def to_s
    grid_to_print = @grid.map do |row|
      row.join('|')
    end

    grid_to_print.unshift('  A B C')

    grid_to_print.each_with_index do |_element, index|
      next if index.zero?

      grid_to_print[index] = "#{index} #{grid_to_print[index]}"
    end

    grid_to_print.join("\n")
  end

  # Public predicate method that acts as an in-between for the private
  # update_grid() method for better code readility
  def update_grid_successful?(row_index, column_index, player_symbol)
    update_grid(row_index, column_index, player_symbol)
  end

  private

  # Updates the grid with the player's move.
  def update_grid(row_index, column_index, player_symbol)
    if @grid[row_index][column_index] == ' '
      @grid[row_index][column_index] = player_symbol
    end
  end
end

module ValidatePlayerInput
  # Returns an array with the nine different possible choices a player can make
  def possible_player_choices
    acceptable_player_choices = []
    i = 1

    3.times do
      ('A'..'C').each do |letter|
        acceptable_player_choices.push(letter + i.to_s)
      end

      i += 1
    end

    acceptable_player_choices
  end

  # Validate player's input
  def acceptable_player_input?(player_input)
    possible_player_choices.include?(player_input)
  end

  # Changes player's input from a string in the form of "A1" into an
  # array of indices that can be used to access the grid cells of the grid
  def transform_player_input(player_input)
    player_input_array = player_input.split('')
    player_input_array[0] = player_input_array[0].ord - 'A'.ord
    player_input_array[1] = player_input_array[1].to_i - 1

    player_input_array.reverse
  end
end

class Player
  include ValidatePlayerInput

  attr_reader :name, :player_symbol

  def initialize(player_symbol, name)
    @player_symbol = player_symbol
    @name = name
  end

  # Get player input, validate, and return move selection to be made
  def make_move
    # Get player input
    print 'Enter your move selection (in the form of D4): '
    player_input = gets.chomp

    # Validate through module methods
    until acceptable_player_input?(player_input)
      puts 'Invalid input. Try again.'
      print 'Enter your move selection (in the form of D4): '
      player_input = gets.chomp
    end

    player_input_array = transform_player_input(player_input)

    # Return input as array of [row_index, column_index, player_symbol]
    [player_input_array[0], player_input_array[1], @player_symbol]
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
    puts '-- That spot has already been played. Try again.'
    player_move = player.make_move
  end
end

def player_name(symbol)
  print "Enter name of player who will use '#{symbol}': "
  gets.chomp
end

def play_game
  players = [Player.new('x', player_name('x')), Player.new('o', player_name('o'))]
  sleep(1)
  puts "\n"
  puts 'The player who will start the game will be chosen at random.'
  puts 'The first player is...'
  player1 = players.sample
  sleep(3)
  puts "#{player1.name}!"
  puts "\n"
  player2 = player1.name == players[0].name ? players[1] : players[0]

  grid = Grid.new
  turns_taken = 0
  winner_declared = false
  winning_player = nil
  puts grid

  while turns_taken <= 9
    puts '----------------------------'
    puts "#{player1.name}'s turn (\"#{player1.player_symbol}\")"
    player_make_move(player1, grid)

    turns_taken += 1
    puts grid

    if turns_taken >= 5 && check_grid_for_winner(grid.grid)
      winner_declared = true
      winning_player = player1
      break
    end

    break if turns_taken >= 9

    puts '----------------------------'
    puts "#{player2.name}'s turn (\"#{player2.player_symbol}\")"
    player_make_move(player2, grid)

    turns_taken += 1
    puts grid

    if turns_taken >= 5 && check_grid_for_winner(grid.grid)
      winner_declared = true
      winning_player = player2
      break
    end
  end

  if winner_declared
    puts "#{winning_player.name} wins!"
  else
    puts 'Game is a draw!'
  end
end

play_game
