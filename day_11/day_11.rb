$monkeys = []

class Monkey
  attr_reader :current_items, :inspections, :totally_relieved, :test_conditions, :operation, :test_division, :id

  def initialize(settings, totally_relieved:)
    @id = settings[:id]
    @test_conditions = settings[:test_conditions]
    @operation = settings[:operation]
    @test_division = settings[:test_division]

    @current_items = settings[:starting_items].dup
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
      worry_level = inspect_item(item)
      result = worry_level % test_division == 0

      throw_to_monkey(test_conditions[result.to_s.to_sym], worry_level)
    end

    @inspections += current_items.count
    @current_items = []
  end

  def throw_to_monkey(monkey_id, item)
    $monkeys[monkey_id].current_items << item
  end

  def inspect_item(item)
    level = eval(operation.gsub("old", item.to_s))

    level /= 3 unless totally_relieved

    level % $monkeys.map(&:test_division).reduce(&:*)
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

  $monkeys.map { |monkey| monkey.inspections }.sort.last(2).reduce(&:*)
end

# puts part_1
puts part_2
