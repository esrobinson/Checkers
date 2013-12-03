class InvalidMoveError < StandardError
end

class InvalidPieceError < InvalidMoveError
  def initialize(msg = "You must choose one of your own pieces.")
    super
  end
end