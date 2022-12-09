@data = File.read("input.txt").split("\n")

@ropes = [*(0..9).map { { x: 0, y: 0 } }]

@last_ropes_state = @ropes.dup

@visited_tail_positions = []

# def must_move_tail?(rope)
#   (rope[0][:x] - rope[1][:x]).abs > 1 ||
#     (rope[0][:y] - rope[1][:y]).abs > 1
# end

def compute_new_knot_position(rope, old_next_pos)
  # move = { x: (rope[1][:x] - rope[0][:x]), y: (rope[1][:y] - rope[0][:y]) }

  # new_pos = old_next_pos

  # if move[:x] == 2
  #   new_pos[:x] = rope[0][:x] + 1
  # end

  # if move[:x] == -2
  #   new_pos[:x] = rope[0][:x] - 1
  # end

  # if move[:y] == 2
  #   new_pos[:y] = rope[0][:y] + 1
  # end

  # if move[:y] == -2
  #   new_pos[:y] = rope[0][:y] - 1
  # end

  # new_pos
end

def move_ropes_of(y, x)
  # @last_ropes_state = @ropes.map { |r| r.dup }

  # @ropes[9][:x] += x
  # @ropes[9][:y] += y

  # (0..8).reverse_each do |i|
  #   rope = [@ropes[i], @ropes[i + 1]]

  #   puts "#{rope.join(',')}"

  #   if must_move_tail?(rope)
  #     puts "#{i} has to move => #{@last_ropes_state[i + 1].dup}"
  #     @ropes[i] = compute_new_knot_position(rope, @last_ropes_state[i + 1].dup)
  #   end
  # end
end

def move_ropes(direction, count)
  count.times do |i|
    case direction
    when 'U'
      move_ropes_of(-1, 0)
    when 'D'
      move_ropes_of(1, 0)
    when 'L'
      move_ropes_of(0, -1)
    when 'R'
      move_ropes_of(0, 1)
    end

    puts @ropes.join(',')

    @visited_tail_positions << @ropes[0].dup
  end
end

def part_2
  @data.each do |line|
    puts line
    direction, count = line.split(' ')

    move_ropes(direction, count.to_i)
  end
end

part_2

puts @visited_tail_positions.uniq.count
