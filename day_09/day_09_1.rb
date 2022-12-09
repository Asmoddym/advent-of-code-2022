@data = File.read("input.txt").split("\n")

@rope_position = [{ x: 0, y: 0 }, { x: 0, y: 0 }]
@visited_tail_positions = []

def must_move_tail?
  (@rope_position[0][:x] - @rope_position[1][:x]).abs > 1 ||
    (@rope_position[0][:y] - @rope_position[1][:y]).abs > 1
end

def move_rope_of(x, y)
  @rope_position[1][:x] += x
  @rope_position[1][:y] += y

  if must_move_tail?
    @rope_position[0][:x] = @rope_position[1][:x] - x
    @rope_position[0][:y] = @rope_position[1][:y] - y
  end
end

def move_rope(direction, count)
  count.times do |i|
    case direction
    when 'U'
      move_rope_of(-1, 0)
    when 'D'
      move_rope_of(1, 0)
    when 'L'
      move_rope_of(0, -1)
    when 'R'
      move_rope_of(0, 1)
    end

    @visited_tail_positions << @rope_position[0].dup
  end
end

def part_1
  @data.each do |line|
    direction, count = line.split(' ')

    move_rope(direction, count.to_i)
  end
end

part_1

puts @visited_tail_positions.uniq.count
