@data = File.read("input.txt")

@nodes = []

def new_node(path, previous: nil)
  node = { name: path, previous: previous, dirs: [], files: [] }
  @nodes << node

  node
end

@tree = new_node('/')

def generate_current_path(current_path, path)
  return current_path[:previous] || @tree if path == '..'
  return @tree if path == '/'

  dir = current_path[:dirs].select { |dir| dir[:name] == path }.first

  current_path[:dirs] << new_node(path, previous: current_path) if dir.nil?

  dir.nil? ? current_path[:dirs].last : dir
end

def populate_current_path(path, content)
  content.each do |line|
    parts = line.split(' ')

    next unless parts.first != 'dir'

    if path[:files].select { |file| file[:name] == parts.last }.first.nil?
      path[:files] << { name: parts.last, size: parts.first.to_i }
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

def calculate_nodes_side(node)
  node_size = node[:files].sum { |file| file[:size] }
  node_size += node[:dirs].sum { |dir| calculate_nodes_side(dir) } if node[:dirs].any?

  node[:size] = node_size
end

compute_tree
calculate_nodes_side(@tree)

# Part 1

puts @nodes.sum { |node| node[:size] <= 100000 ? node[:size] : 0 }

# Part 2

unused_space = 70000000 - @tree[:size]

puts @nodes
      .select { |node| unused_space + node[:size] >= 30000000 }
      .sort { |a, b| a[:size] <=> b[:size] }
      .first[:size]
