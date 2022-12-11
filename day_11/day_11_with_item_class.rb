$monkeys = []
$items = []

class Item
  attr_accessor :value, :held_by_monkeys

  def initialize(value)
    @value = value
    @held_by_monkeys = []
  end

  def inspect
    str = value.to_s
    held_by_monkeys.each do |id|
      str = "((#{$monkeys[id].operation.gsub("old", str)}))"
    end

    puts str

    eval(str)

  end
end

class Monkey
  attr_reader :current_items, :inspections, :totally_relieved, :test_conditions, :operation, :test_division, :id

  def initialize(settings, totally_relieved:)
    @id = settings[:id]
    @test_conditions = settings[:test_conditions]
    @operation = settings[:operation]
    @test_division = settings[:test_division]
    
    @current_items = []
    settings[:starting_items].each do |item|
      obj = Item.new(item)
      $items << obj

      @current_items << obj
    end

    # @current_items = settings[:starting_items].map { |item| Item.new(item) } #settings[:starting_items].dup
    @inspections = 0
    @totally_relieved = totally_relieved
  end

  def self.build(raw_data, totally_relieved:)
    lines = raw_data.split("\n")

    Monkey.new({
      id: lines[0].split(" ").last[0..-2].to_i,
      starting_items: lines[1].split(": ").last.split(", ").map { |value| value.to_i },
      operation: lines[2].split(": ").last.split(" = ").last,
      test_division: lines[3].split("divisible by ").last.to_i,
      test_conditions: { true: lines[4].split("to monkey ").last.to_i, false: lines[5].split("to monkey ").last.to_i }
    },
    totally_relieved: totally_relieved)
  end

  def play_round
    current_items.each_with_index do |item, i|
      item.held_by_monkeys << id
      # item.held_by_monkeys[id] ||= 0
      # item.held_by_monkeys[id] += 1
      
      # puts "#{id}: checking item (#{item.value})"

      # item.value = inspect_item(item.value)
      # result = item.value % test_division == 0

      result = item.inspect % test_division == 0
      # puts ">> #{item.inspect}"

      throw_to_monkey(test_conditions[result.to_s.to_sym], item)
    end

    @inspections += current_items.count
    @current_items = []
  end

  def throw_to_monkey(monkey_id, item)
    $monkeys[monkey_id].current_items << item
  end

  def inspect_item(value)
    level = eval(operation.gsub("old", value.to_s))

    level /= 3 unless totally_relieved

    level
  end
end

def generate_rules(totally_relieved: false)
  $monkeys = []

  File.read("input.txt").split("\n\n").each do |data|
    monkey = Monkey.build(data, totally_relieved: totally_relieved)

    $monkeys[monkey.id] = monkey
  end
end

def part_1
  generate_rules
  20.times { $monkeys.each(&:play_round) }

  puts $monkeys.map { |m| m.id.to_s + ": " + m.current_items.map(&:inspect).join(', ') }.join(' | ')

  $monkeys.map { |monkey| monkey.inspections }.sort.last(2).reduce(&:*)
end

def part_2
  generate_rules(totally_relieved: true)
  10000.times do |i|
    $monkeys.each do |monkey|
      a = Time.now
      monkey.play_round
      b = Time.now; puts "#{i}: #{b - a}" # (#{$monkeys.map { |a| a.current_items.join(',')}}"
    end
  end

  $monkeys.map { |monkey| monkey.inspections }.sort#.last(2).reduce(&:*)
end

# puts part_1
puts part_2
