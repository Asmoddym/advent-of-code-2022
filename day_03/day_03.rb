data = File.read("input.txt")

# PART 1

def check_common_items_in_parts(parts)
  parts.first.each_with_object([]) do |char, common_items|
    next unless parts[1..-1].select { |part| part.include?(char) }.size == parts.size - 1

    common_items << char
  end.uniq
end

def calculate_items_total(items)
  total = 0

  items.each do |item|
    total += (item.ord >= 97 ? item.ord - 97 : item.ord - (65 - 26)) + 1
  end

  total
end

total = 0
data.split("\n").each do |line|
  parts = line.split('').each_slice((line.size / 2).round).to_a

  common_items = check_common_items_in_parts(parts)

  total += calculate_items_total(common_items)
end

puts total


# PART 2

total = 0
data.split("\n").each_slice(3) do |group|
  common_items = check_common_items_in_parts(group.map { |line| line.split('') })

  total += calculate_items_total(common_items)
end

puts total
