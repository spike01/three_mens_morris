require 'board'

RSpec.describe Board do
  let(:board) { Board.new }

  it "has an empty board on starting" do
    expect(board.to_s).to eq(['---','---','---'].join("\n"))
  end

  it "places the first counter on the board" do
    board.place(5, :white)

    expect(board.to_s).to eq(['---','--W','---'].join("\n"))
  end

  it "knows if a placement is invalid" do
    board.place(5, :white)

    expect(board.valid_placement?(5)).to be_falsey
  end

  it "knows if a placement is valid" do
    board.place(5, :white)

    expect(board.valid_placement?(6)).to be_truthy
  end

  it "can move an already placed counter" do
    board.place(5, :white)
    board.move(5, 6, :white)

    expect(board.to_s).to eq(['---','---','W--'].join("\n"))
  end

  context "when validating moving a piece" do
    it "knows if moving a counter is invalid because the counter is of the wrong colour" do
      board.place(5, :white)

      expect(board.valid_movement?(5, 6, :black)).to be_falsey
    end

    it "knows if moving a counter is invalid because the counter is of the wrong colour" do
      board.place(5, :white)

      expect(board.valid_movement?(5, 6, :black)).to be_falsey
    end

    it "knows if moving a counter is invalid because the destination is occupied" do
      board.place(5, :white)
      board.place(4, :black)

      expect(board.valid_movement?(5, 4, :white)).to be_falsey
    end

    it "knows if moving a counter is valid because the counter is the correct colour" do
      board.place(5, :white)

      expect(board.valid_movement?(5, 6, :white)).to be_truthy
    end
  end

  context "when determining the winner" do
    it "doesn't declare a winner if there are no counters" do
      expect(board.winner).to eq(:no_winner)
    end

    it "handles horizontal wins for white" do
      board.place(0, :white)
      board.place(1, :white)
      board.place(2, :white)

      expect(board.winner).to eq(:white)
    end

    it "handles horizontal wins for black" do
      board.place(0, :black)
      board.place(1, :black)
      board.place(2, :black)

      expect(board.winner).to eq(:black)
    end

    it "handles vertical wins for black" do
      board.place(0, :black)
      board.place(3, :black)
      board.place(6, :black)

      expect(board.winner).to eq(:black)
    end

    it "handles vertical wins for white" do
      board.place(2, :white)
      board.place(5, :white)
      board.place(8, :white)

      expect(board.winner).to eq(:white)
    end

    it "handles diagonal wins left to right for white" do
      board.place(0, :white)
      board.place(4, :white)
      board.place(8, :white)

      expect(board.winner).to eq(:white)
    end

    it "handles diagonal wins right to left for black" do
      board.place(2, :black)
      board.place(4, :black)
      board.place(6, :black)

      expect(board.winner).to eq(:black)
    end

    it "is won when white wins" do
      board.place(2, :white)
      board.place(5, :white)
      board.place(8, :white)

      expect(board).to be_won
    end

    it "is won when black wins" do
      board.place(2, :black)
      board.place(4, :black)
      board.place(6, :black)

      expect(board).to be_won
    end

    it "isn't won when there is no winner" do
      expect(board).not_to be_won
    end
  end
end
