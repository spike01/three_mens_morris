require "client"

RSpec.describe Client do
  let(:std_in) { spy(:std_in) }
  let(:std_out) { spy(:std_out) }
  let(:board) { spy(:board) }
  let(:client) { Client.new(std_in, std_out, board) }

  it "asks white to make the first move" do
    expect(client.next_player).to eq(:white)
  end

  it "after accepting a first move from white, the next player is black" do
    client.ask_player_for_move

    expect(client.next_player).to eq(:black)
  end

  it "after white has moved and black has moved, it is white's turn again" do
    client.ask_player_for_move
    client.ask_player_for_move

    expect(client.next_player).to eq(:white)
  end

  it "accepts a move from the player" do
    client.ask_player_for_move

    expect(std_in).to have_received(:gets)
  end

  it "passes the move to the board, zero indexed" do
    allow(std_in).to receive(:gets).and_return("1")
    client.ask_player_for_move

    expect(board).to have_received(:place).with(0, :white)
  end

  it "changes to switching pieces after the 6th move, zero indexed" do
    6.times { allow(std_in).to receive(:gets).and_return("1") }
    6.times { client.ask_player_for_move }
    allow(std_in).to receive(:gets).and_return("1 2")
    client.ask_player_for_move

    expect(board).to have_received(:move).with(0, 1, :white)
  end

  it "displays the board" do
    client.display_board

    expect(std_out).to have_received(:puts)
  end

  context "when determining the winner" do
    it "knows when the game hasn't been won" do
      allow(board).to receive(:won?).and_return(false)

      expect(client).not_to be_won
    end

    it "knows when the game has been won" do
      allow(board).to receive(:won?).and_return(true)

      expect(client).to be_won
    end

    it "announces the winner" do
      allow(board).to receive(:winner).and_return(:black)

      client.display_winner

      expect(std_out).to have_received(:puts).with("Black wins")
    end
  end

  context "when handling invalid moves" do
    it "doesn't switch turns" do
      allow(board).to receive(:valid_placement?).and_return(false)
      allow(std_in).to receive(:gets).and_return("10")

      client.ask_player_for_move

      expect(client.next_player).to eq(:white)
    end

    it "doesn't switch turns after 6 moves" do
      6.times { allow(std_in).to receive(:gets).and_return("1") }
      6.times { client.ask_player_for_move }
      allow(board).to receive(:valid_movement?).and_return(false)
      allow(std_in).to receive(:gets).and_return("20 15")

      client.ask_player_for_move

      expect(client.next_player).to eq(:white)
    end
  end

  describe "displaying messages to the user" do
    it "asks for input" do
      client.ask_player_for_move

      expect(std_out).to have_received(:puts).with("Please enter a number between 1 and 9")
    end
  end
end
