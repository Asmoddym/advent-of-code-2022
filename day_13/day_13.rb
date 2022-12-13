def compare_items(left, right)
  if left.is_a?(Integer) && right.is_a?(Integer)
    return left == right ? :no_idea : (left < right ? :ok : :ko)
  end

  if left.is_a?(Array) && right.is_a?(Array)
    left.count.times do |idx|
      return :ok if left[idx].nil? && !right[idx].nil?
      return :ko if !left[idx].nil? && right[idx].nil?

      result = compare_items(left[idx], right[idx])
      return result if result != :no_idea
    end

    return left.count == right.count ? :no_idea : :ok
  end

  return compare_items(left.is_a?(Array) ? left : [left], right.is_a?(Array) ? right : [right])
end

def compare_pair(lists)
  lists.first.count.times do |idx|
    return false if lists.last[idx].nil?

    result = compare_items(lists.first[idx], lists.last[idx])

    return result == :ok if result != :no_idea
  end

  true
end

def part_1
  count = 0

  File.read("input.txt").split("\n\n").each_with_index do |pair, idx|
    count += idx + 1 if compare_pair(pair.split("\n").map { |list| eval(list) })
  end

  count
end

def part_2
  all_lines = [[[2]], [[6]]] + File.read("input.txt").split("\n").map do |line|
    line.empty? ? nil : eval(line)
  end.compact

  sorted = all_lines.sort { |a, b| compare_pair([a, b]) ? -1 : 1 }
  
  (sorted.find_index { |line| line == [[2]] } + 1) * (sorted.find_index { |line| line == [[6]] } + 1)
end

puts part_1
puts part_2
