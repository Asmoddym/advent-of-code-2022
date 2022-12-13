def compare_items(left, right)
  # puts "comparing #{left} and #{right}"
  # sleep(0.5)
  if left.is_a?(Integer) && right.is_a?(Integer)
    # puts "ALKZAE"
    return left == right ? :no_idea : (left < right ? :ok : :ko)
  end

  if left.is_a?(Array) && right.is_a?(Array)
    # puts "QSKDQSLKH"

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

def compare_pair(pair)
  lists = pair.split("\n").map { |list| eval(list) }

  # puts "Trying #{lists.first[0]}, #{lists.last[0]}"
  puts "#{lists}"
  # puts compare_items(lists.first[0], lists.last[0])

  lists.first.count.times do |idx|
    return false if lists.last[idx].nil?

    result = compare_items(lists.first[idx], lists.last[idx])

    return result == :ok if result != :no_idea

    # return false unless compare_items(lists.first[idx], lists.last[idx])
  end

  # lists = lists.map { |list| flatten_to_death(list) }

  # lists.first.each_with_index do |item, i|
  #   return false if lists.last[i].nil?
  #   return lists.last[i] > item if lists.last[i] != item
  # end

  true
end

def part_1
  count = 0

  File.read("input.txt").split("\n\n").each_with_index do |pair, idx|
    idx += 1

    # next unless idx == 2

    result = compare_pair(pair)
    if result
      count += idx
      puts idx
    end

    # exit if idx == 2
  end

  count
end

puts part_1
