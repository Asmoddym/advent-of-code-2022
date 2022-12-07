@data = File.read("input.txt")

@tree = { name: '/', previous: nil, dirs: [], files: [] }

def generate_current_path(current_path, path)
  return current_path[:previous].nil? ? @tree : current_path[:previous] if path == '..'
  return @tree if path == '/'

  dir = current_path[:dirs].select { |dir| dir[:name] == path }.first

  current_path[:dirs] << { name: path, previous: current_path, dirs: [], files: [] } if dir.nil?

  dir.nil? ? current_path[:dirs].last : dir
end

def populate_current_path(path, content)
  content.each do |line|
    parts = line.split(' ')

    if parts.first != 'dir' && path[:files].select { |file| file[:name] == parts.last }.first.nil?
      path[:files] << { name: parts.last, size: parts.first }
    end
  end
end

def compute_tree
  current_path = @tree

  @data.split("$ ").each do |command|
    next if command.empty?

    parts = command.split("\n")

    case parts.first.split(' ').first
    when 'cd'
      current_path = generate_current_path(current_path, parts.first.split(' ').last)
    when 'ls'
      populate_current_path(current_path, parts[1..-1])
    end
  end
end

@total_under_limit = 0

def calculate_total_size(node)
  node_size = 0

  if node[:dirs].any?
    node_size = node[:dirs].sum { |dir| calculate_total_size(dir) }
  end

  node_size += node[:files].sum { |file| file[:size].to_i }

  @total_under_limit += node_size if node_size <= 100000

  node_size
end

compute_tree

calculate_total_size(@tree)

puts @total_under_limit
