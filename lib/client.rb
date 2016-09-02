class Client
  def initialize(input_stream, output_stream, board)
    @input_stream = input_stream
    @output_stream = output_stream
    @board = board
    @next_player = :white
    @counters = 6
  end

  def next_player
    @next_player
  end

  def ask_player_for_move
    @output_stream.puts("Please enter a number between 1 and 9")
    input = @input_stream.gets
    if @counters > 0
      return if !@board.valid_placement?(input.to_i.pred)
      @board.place(input.to_i.pred, @next_player)
      @counters -= 1
    else
      return if !@board.valid_movement?(*input.split(" ").map(&:to_i).map(&:pred), @next_player)
      @board.move(*input.split(" ").map(&:to_i).map(&:pred), @next_player)
    end
    switch_players
  end

  def display_board
    @output_stream.puts(@board.to_s)
  end

  def won?
    @board.won?
  end

  def display_winner
    @output_stream.puts("#{@board.winner.capitalize} wins")
  end

  private

  def switch_players
    @next_player = @next_player == :black ? :white : :black
  end
end
