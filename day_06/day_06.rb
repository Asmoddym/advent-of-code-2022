@data = File.read("input.txt")

def get_first_marker(start_size)
  result = @data.chars.each_with_index do |char, idx|
    last_chars = @data[idx - start_size..idx - 1].chars

    break idx if idx >= start_size && last_chars.uniq == last_chars
  end
end

puts get_first_marker(4)
puts get_first_marker(14)
