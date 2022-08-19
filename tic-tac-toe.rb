class Board
  def initialize
    @board = Array.new(3).map do
      Array.new(3, ' ')
    end
  end

  def to_s
    board_to_print = @board.map do |row|
      row.join('|')
    end

    board_to_print.join("\n")
  end

  def update_board(row_index, column_index, player_symbol)
    @board[row_index][column_index] = player_symbol
  end
end
