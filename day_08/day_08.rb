@data = File.read("input.txt").split("\n")

def tree_is_visible?(x, y)
  return true if x == 0 || x == @data.first.size - 1
  return true if y == 0 || y == @data.count - 1

  tree = @data[y][x]

  hidden_sides = 0

  hidden_sides += 1 if (0..y - 1).select { |pos| @data[pos][x] >= tree }.any?
  hidden_sides += 1 if (y + 1..@data.count - 1).select { |pos| @data[pos][x] >= tree }.any?

  hidden_sides += 1 if (0..x - 1).select { |pos| @data[y][pos] >= tree }.any?
  hidden_sides += 1 if (x + 1..@data[y].size - 1).select { |pos| @data[y][pos] >= tree }.any?

  hidden_sides != 4
end

def calculate_scenic_score(x, y)
  tree = @data[y][x]

  north = y - ((0..y - 1).select { |pos| @data[pos][x] >= tree }.last || 0)
  west = x - ((0..x - 1).select { |pos| @data[y][pos] >= tree }.last || 0)

  south = ((y + 1..@data.count - 1).select { |pos| @data[pos][x] >= tree }.first || @data.count - 1) - y
  east = ((x + 1..@data[y].size - 1).select { |pos| @data[y][pos] >= tree }.first || @data[y].size - 1) - x

  north * south * west * east
end

def part_1
  visible_trees = 0

  (0..@data.count - 1).each do |y|
    @data[y].chars.each_with_index do |tree, x|
      visible_trees += 1 if tree_is_visible?(x, y)
    end
  end

  visible_trees
end

def part_2
  max_score = 0

  (0..@data.count - 1).each do |y|
    @data[y].chars.each_with_index do |tree, x|
      if tree_is_visible?(x, y)
        score = calculate_scenic_score(x, y)

        max_score = score if score > max_score
      end
    end
  end

  max_score
end

puts part_1
puts part_2
