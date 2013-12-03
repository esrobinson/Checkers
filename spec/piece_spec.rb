require 'rspec'
require 'piece'

describe Piece do
  let(:board) { double("Board", :empty? => true, :dup => 2 ) }
  subject(:piece) { Piece.new([0,0], :r, nil) }

  it 'has a position' do
    expect(piece.position).to eq([0,0])
  end

  it 'has a color' do
    expect(piece.color).to be(:r)
  end

  it 'is not a king' do
    expect(piece.king).to be(false)
  end

  it 'can slide to an empty square' do
    piece.perform_moves!([[1,1]])
    expect(piece.position).to eq([1,1])
  end

end

