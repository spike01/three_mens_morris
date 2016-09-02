class Board
  def initialize
    @board = [:-, :-, :-,
              :-, :-, :-,
              :-, :-, :-]
  end

  def place(location, colour)
    @board[location] = colour
  end

  def move(from, to, colour)
    @board[from] = :-
    @board[to] = colour
  end

  def valid_movement?(from, to, colour)
    @board[from] == colour && valid_placement?(to)
  end

  def valid_placement?(location)
    @board[location] == :-
  end

  def winner
    return :white if horizontal_win(:white) || vertical_win(:white) || diagonal_win(:white)
    return :black if horizontal_win(:black) || vertical_win(:black) || diagonal_win(:black)
    :no_winner
  end

  def to_s
    printable_board.each_slice(3)
      .map { |slice| slice.join('') }
      .join("\n")
  end

  def won?
    winner != :no_winner
  end

  private

  def horizontal_win(counter)
    all_same_counter?(rows, counter)
  end

  def vertical_win(counter)
    all_same_counter?(rows.transpose, counter)
  end

  def diagonal_win(counter)
    diagonals = [[0, 4, 8], [2, 4, 6]]
    diagonals.any? do |diagonal| 
      diagonal.all? { |position| @board[position] == counter }
    end
  end

  def all_same_counter?(rows, counter)
    rows.any? { |row| row.all? { |position| position == counter } }
  end

  def rows
    @board.each_slice(3).to_a
  end

  def printable_board
    @board.map do |position|
      if position == :-
        :-
      elsif position == :white
        :W 
      elsif position == :black
        :B
      end
    end
  end
end
