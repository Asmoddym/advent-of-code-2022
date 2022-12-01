elf_data = []
content = File.read("input.txt")

elf_data = content.split("\n\n").each_with_object([]) do |elf_section, aggr|
  total = 0
  elf_section.split("\n").each { |food| total += food.to_i }

  aggr << total
end.sort!

puts elf_data.last
puts elf_data.last(3).sum
