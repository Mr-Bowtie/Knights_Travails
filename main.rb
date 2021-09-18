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

  def possible_single_step_moves
    moves = []
    knight.moveset.each do |x, y|
      new_position = [knight.position[0] + x, knight.position[1] + y]
      moves << new_position if cells.include?(new_position)
    end
    moves
  end
end

class Node
  attr_accessor :children, :parent
  attr_reader :position

  def initialize(position)
    @position = position
    @children = []
    @parent = nil
  end
end

class Knight
  attr_accessor :position
  attr_reader :moveset

  def initialize(position)
    @position = position
    @moveset = [[-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2]]
  end
end

class MoveTree
  attr_accessor :root

  def initialize(root)
    @root = Node.new(root)
  end

  def connect(parent, child)
    parent.children << child
    child.parent = parent
  end

  # returns the node whose position is the same as the value
  # if no value is given return an array with all possible positions added in level order
  def level_order_search(value = nil)
    position_array = []
    current_node = @root
    queue = [] << current_node
    until queue.empty?
      return current_node if current_node.position == value
      current_node.children.each { |node| queue << node }
      position_array << queue.shift.position
      current_node = queue[0]
    end
    position_array
  end

  def print_connections(node = @root)
    return if node.children.empty?
    position_array = []
    node.children.each { |nd| position_array << nd.position }
    puts "#{node.position} -> #{position_array}"

    for i in node.children
      print_connections(i)
    end
  end

  def shortest_path(start, destination)
    current_node = level_order_search(destination)
    path = []
    until current_node.position == start
      path.unshift(current_node.position)
      current_node = current_node.parent
    end
    path.unshift(start)
  end

  def display_shortest_path(start, destination)
    path = shortest_path(start, destination)
    puts "=: You made it in #{path.size - 1} moves! Here's your path:"
    for step in path
      p step
    end
  end
end

def knight_moves(start, finish)
  knight = Knight.new(start)
  chess_board = Board.new(knight)
  move_tree = MoveTree.new(knight.position)
  queue = [] << move_tree.root

  loop do
    possible_moves = chess_board.possible_single_step_moves
    current_tree_values = move_tree.level_order_search

    for i in possible_moves
      next if current_tree_values.include?(i)
      node = Node.new(i)
      move_tree.connect(queue[0], node)
      queue << node

      # return move_tree.print_connections if possible_moves.index(i) == 3
    end
    queue.shift
    break if queue.empty?
    knight.position = queue[0].position
  end
  move_tree.display_shortest_path(start, finish)
end

knight_moves([0, 0], [1, 2])
knight_moves([0, 0], [3, 3])
knight_moves([3, 3], [0, 0])
knight_moves([3, 3], [7, 7])
