class Board
  attr_accessor :cells, :knight

  def initialize(knight)
    @knight = knight
    @cells = []
    8.times do |i|
      8.times do |j|
        cells << [i, j]
      end
    end
  end

  def possible_moves
    moves = []
    knight.moveset.each do |x, y|
      new_position = [knight.position[0] + x, knight.position[1] + y]
      moves << new_position if cells.include?(new_position)
    end
    moves
  end
end

class Node
  attr_accessor :connected_nodes
  attr_reader :position

  def initialize(position)
    @position = position
    @connected_nodes = []
  end
end

class Knight
  attr_accessor :position
  @@moveset = [[-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2]]

  def initialize(position)
    @position = position
  end

  def moveset
    @@moveset
  end
end

knight = Knight.new([0, 0])
chess_board = Board.new(knight)
p chess_board.possible_moves
