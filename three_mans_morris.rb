require "./lib/board"
require "./lib/client"

board = Board.new
client = Client.new(STDIN, STDOUT, board)

while !client.won?
  client.display_board
  client.ask_player_for_move
end
client.display_winner

exit
