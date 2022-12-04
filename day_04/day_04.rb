data = File.read("input.txt").split("\n")

def compute_sections_per_elf(line)
  line.split(',').map do |section|
    parts = section.split('-')

    [*parts.first.to_i..parts.last.to_i]
  end
end

results = data.each_with_object({ part_1: 0, part_2: 0 }) { |line, aggr|
  sections_per_elf = compute_sections_per_elf(line)

  matches = sections_per_elf.first & sections_per_elf.last

  aggr[:part_1] += sections_per_elf.include?(matches) ? 1 : 0
  aggr[:part_2] += matches.any? ? 1 : 0
}

puts results[:part_1]
puts results[:part_2]
