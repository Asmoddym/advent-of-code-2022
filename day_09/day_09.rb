@data = File.read("input.txt").split("\n")

@knots = []
@visited_tail_positions = []
@number_of_knots = 0

def generate_knots
  @knots = [*(0..@number_of_knots).map { { x: 0, y: 0 } }]
  @visited_tail_positions = []
end

def calculate_difference_between_knots(knot, relative_knot)
  { x: relative_knot[:x] - knot[:x], y: relative_knot[:y] - knot[:y] }
end

def compute_knot_move(i, y, x)
  knot = @knots[i]

  return { x: knot[:x] + x, y: knot[:y] + y } if i == 0

  difference = calculate_difference_between_knots(knot, @knots[i - 1])

  # In the case of a diagonal, we know we have to move both values. Else, just 1 value needs to be moved.
  {
    x: knot[:x] + ((difference[:x].abs == 2) ? (difference[:x] <=> 0) : (difference[:y].abs == 2 ? difference[:x] : 0)),
    y: knot[:y] + ((difference[:y].abs == 2) ? (difference[:y] <=> 0) : (difference[:x].abs == 2 ? difference[:y] : 0))
  }
end

def move_knots_to_direction(y, x)
  (0..@number_of_knots - 1).each do |i|
    @knots[i] = compute_knot_move(i, y, x)
  end
end

def move_knots(direction, count)
  count.times do |i|
    case direction
    when 'U'
      move_knots_to_direction(-1, 0)
    when 'D'
      move_knots_to_direction(1, 0)
    when 'L'
      move_knots_to_direction(0, -1)
    when 'R'
      move_knots_to_direction(0, 1)
    end

    @visited_tail_positions << @knots[@number_of_knots - 1].dup
  end
end

def perform(number_of_knots)
  @number_of_knots = number_of_knots
  generate_knots

  @data.each do |line|
    direction, count = line.split(' ')

    move_knots(direction, count.to_i)
  end

  @visited_tail_positions.uniq.count
end

puts perform(2)
puts perform(10)
