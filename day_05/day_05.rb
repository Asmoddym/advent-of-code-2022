@header, @instructions = File.read("input.txt").split("\n\n").map { |part| part.split("\n") }

@stacks = {}

def get_crates_per_stack(index)
  @header[0..-2].map { |line| line[index].strip }.reject(&:empty?)
end

def compute_initial_stacks_configuration
  @header.last.split(' ').each_with_index do |id, i|
    @stacks[id] = { index: 1 + i + i * 3, crates: { part_1: [], part_2: [] } }
  end

  @stacks.keys.each do |stack_id|
    crates = get_crates_per_stack(@stacks[stack_id][:index])

    @stacks[stack_id][:crates] = { part_1: crates.dup, part_2: crates.dup }
  end
end

def move_crates
  @instructions.each do |instruction|
    number, from, to = instruction.match(/move (\d+) from (\d+) to (\d+)/).to_a[1..-1]

    crates_part_1 = @stacks[from][:crates][:part_1].shift(number.to_i).reverse
    crates_part_2 = @stacks[from][:crates][:part_2].shift(number.to_i)

    @stacks[to][:crates][:part_1] = (crates_part_1 + @stacks[to][:crates][:part_1]).flatten
    @stacks[to][:crates][:part_2] = (crates_part_2 + @stacks[to][:crates][:part_2]).flatten
  end
end

compute_initial_stacks_configuration
move_crates

puts @stacks.keys.map { |key| @stacks[key][:crates][:part_1][0] }.join
puts @stacks.keys.map { |key| @stacks[key][:crates][:part_2][0] }.join
