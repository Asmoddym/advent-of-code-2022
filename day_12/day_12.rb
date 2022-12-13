class Graph
  attr_reader :maze, :start, :ending, :intersections, :paths, :distances

  def initialize
    @maze = File.read("input.txt").split("\n")
    @intersections = []
    @distances = []

    process_data
  end

  def resolve_maze
    @paths = []

    path = []

    path = bla(start_intersection, path, nil)

    puts paths.map { |a| a.count }.sort.join(',')
  end

  def bla(intersection, path, last_coords)
    sleep(0.1)
    display(path)
    if intersection[:directions].count == 1
      puts "DEAD END"
      # puts "nope"
      # return path[0..-2]
      return path
    end

    if paths.any? && path.count > paths.map { |a| a.count }.sort.first
      # puts "useless"
      return path
    end

    intersection[:directions].each do |direction|
      next if direction[:coords] == last_coords

      if path.include?(direction[:coords])
        # puts "LOOP: #{direction[:coords]}"

        # return path

        # return path[0..path.find_index { |a| a == direction[:coords]}]
        # puts "\n\n\nLOOP\n\n\n" if path.include?(direction[:coords])
        # display(path)
        # exit
        next
      end

      # puts "next is #{direction[:coords]} (path: #{path.count})"
      # puts "COUCOU" if direction[:coords] == ending

      paths << path if direction[:coords] == ending
      # puts "FOUND ONE #{path.count}" if direction[:coords] == ending
      # exit if direction[:coords] == ending
      # return if direction[:coords] == ending

      # puts "coucou" if direction[:coords] == ending
      # display(new_path)
      # puts path.join(',')
      path = bla(find_intersection(direction[:coords]), path.dup.push(direction[:coords]), direction[:coords])
      # puts "AFTER: " + path.join(',')

      # if !path.include?(last_coords) # rollback
      #   puts "NOPE: #{direction[:coords]}"
      #   display(path)
      #   exit
      #   return path
      # end


      # path = path[0..-2]

      # puts "\n\n\nENDING A SPIN\n\n\n"
    end

    path

    # path[0..-2]
  end

  def display(path)

    maze.each_with_index do |line, y|
      puts line.chars.map.with_index { |c, x| path.include?({ x: x, y: y}) ? "." : c }.join(',')
    end

    puts "====="
  end

  private

  def find_path(y, x, current_path)

    # current_path.last[:y], current_path.last[:x]
  end

  def start_intersection
    find_intersection(start)
  end

  def find_intersection(coords)
    intersections.find { |i| i[:y] == coords[:y] && i[:x] == coords[:x] }
  end

  def process_data
    @start = find_position('S')
    @ending = find_position('E')

    maze[start[:y]][start[:x]] = 'a'
    maze[ending[:y]][ending[:x]] = 'z'

    compute_distances
    compute_intersections
  end

  def compute_distances
    maze.each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        distances << { x: x, y: y, distance: Math.sqrt(((ending[:x] - x).abs ** 2) + ((ending[:y] - y).abs ** 2)) }
      end
    end
  end

  attr_reader :counter

  def compute_intersections
    maze.each_with_index do |line, y|
      line.chars.each_with_index do |char, x|
        directions = []

        directions << { direction: :up, coords: { y: y - 1, x: x } } if can_go_up?(char, x, y)
        directions << { direction: :down, coords: { y: y + 1, x: x } } if can_go_down?(char, x, y)
        directions << { direction: :left, coords: { y: y, x: x + 1 } } if can_go_left?(char, x, y)
        directions << { direction: :right, coords: { y: y, x: x - 1 } } if can_go_right?(char, x, y)

        # puts directions if y == 2 && x == 4
        # puts char if y == 2 && x == 4

        # directions = directions.sort { }

        # puts "#{directions.map { |a| "#{a[:coords]} => #{find_distance(a[:coords])}" }.join(', ')}"
        # puts "#{directions.sort { |a, b| find_distance(a[:coords]) <=> find_distance(b[:coords]) }.map { |a| a[:coords] }}"

        intersections << { x: x, y: y, directions: directions.sort { |a, b| find_distance(a[:coords]) <=> find_distance(b[:coords]) } }

      end
    end
  end

  def find_distance(coords)
    distances.find { |d| { x: d[:x], y: d[:y] } == coords}[:distance]
  end

  def can_go_up?(char, x, y)
    return false if y == 0

    (char.ord - 1..char.ord + 1).include?(maze[y - 1][x].ord)
  end

  def can_go_down?(char, x, y)
    return false if y == maze.count - 1

    (char.ord - 1..char.ord + 1).include?(maze[y + 1][x].ord)
  end

  def can_go_left?(char, x, y)
    return false if x == maze[0].size - 1

    (char.ord - 1..char.ord + 1).include?(maze[y][x + 1].ord)
  end

  def can_go_right?(char, x, y)
    return false if x == 0

    (char.ord - 1..char.ord + 1).include?(maze[y][x - 1].ord)
  end

  def find_position(letter)
    y = maze.find_index { |line| line.include?(letter) }
    x = maze[y].chars.find_index { |c| c == letter }

    { y: y, x: x }
  end
end

def part_1
  graph = Graph.new

  # graph.maze.each_with_index do |line, y|
  #   puts line.chars.map.with_index { |c, x| graph.intersections.find { |i| i[:y] == y && i[:x] == x }[:directions].count }.join(',')
  # end

  graph.resolve_maze
end

part_1
