require 'prime'

$monkeys = []
$items = []

class Item
  attr_accessor :value, :last_division#, :is_even, :result_for_monkey

  def initialize(value)
    @value = value
    @last_division = nil
#    @is_even = value % 2 == 0
    # @result_for_monkey = []

    # check_for_monkeys
  end

  # def check_for_monkeys
  #   $monkeys.each do |monkey|
  #     @result_for_monkey[monkey.id] = inspect(monkey.operation, monkey.test_division)
  #   end
  # end

  # def inspect
  #   str = value.to_s
  #   held_by_monkeys.each do |id|
  #     str = "((#{$monkeys[id].operation.gsub("old", str)}))"
  #   end

  #   puts str

  #   eval(str)

  # end

  # def inspect(operation, test_division)
  #   operation_nb = operation.split(" ").last.to_i

  #   if operation.include?("*")
  #     return 
  #   else
  #   end
  # end

  # def inspect(operation, test_division)
  #   operation_is_even = operation.split(" ").last.gsub("old", value.to_s).to_i % 2 == 0

  #   if operation.include?("*")
  #     # operation is *

  #     # even * even = even
  #     # even * odd = even

  #     # odd * odd = odd

  #     @is_even = (operation_is_even || is_even)
  #   else
  #     # operation is +

  #     # even + even = even
  #     # odd + odd = even
  #     # even + odd = odd

  #     @is_even = (operation_is_even && is_even) || (!operation_is_even && !is_even)
  #   end

  #   eval(operation.gsub("old", value.to_s)) % test_division == 0
  # end

  attr_accessor :decomposed_per_monkey

  def inspect(monkey)
    @decomposed_per_monkey ||= []

    decomposed_per_monkey[monkey.id] ||= { times: value / monkey.test_division, rest: value % monkey.test_division }
    recomposed_value = decomposed_per_monkey[monkey.id][:times] * monkey.test_division + decomposed_per_monkey[monkey.id][:rest]

    puts "original: #{value}, recomposed: #{recomposed_value}"

    $monkeys.each do |monkey|
      new_value = eval(monkey.operation.gsub("old", recomposed_value.to_s))
      puts "new value for monkey #{monkey.id}: #{new_value} with div #{monkey.test_division}"

      decomposed_per_monkey[monkey.id] = { times: new_value / monkey.test_division, rest: new_value % monkey.test_division }
    end

    puts decomposed_per_monkey

    decomposed_per_monkey[monkey.id][:times] * monkey.test_division + decomposed_per_monkey[monkey.id][:rest]
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
      # item.held_by_monkeys << id
      # item.held_by_monkeys[id] ||= 0
      # item.held_by_monkeys[id] += 1
      
      # puts "#{id}: checking item (#{item.value})"

      # value = inspect_item(item.value)
      # puts value


      # dividers are prime numbers

      # puts value
      # if value.to_s.chars.map(&:to_i).sum % 3 == 0
      #   # can be divided by 3
      # elsif value % 2 == 0
      #   # can be divided by 2
      # end




      # result = value % test_division == 0

      # item.value = value

      # item.inspect(operation, test_division)

      # puts "For #{item.value}: #{inspect_item(item)} #{item.is_even}"

      # result = !item.is_even

      # value = inspect_item(item.value)


      # puts ">> #{result}"

      # if result
      #   item.value = test_division
      # end

      # result = item.inspect(operation, test_division)
      # puts ">> #{item.inspect}"


      # dividable = item.inspect(operation, test_division)

      # result = !item.is_even && dividable


      # operation_is_even = operation.split(" ").last.gsub("old", item.value.to_s).to_i % 2 == 0

      # if operation.include?("*")
      #   # operation is *
      #   # even * even = even
      #   # even * odd = even
      #   # odd * odd = odd
  
      #   is_even = (operation_is_even || is_even)
      # else
      #   # operation is +
      #   # even + even = even
      #   # odd + odd = even
      #   # even + odd = odd
  
      #   is_even = (operation_is_even && is_even) || (!operation_is_even && !is_even)
      # end

      # new_value = eval(operation.gsub("old", item.value.to_s))
      # is_dividable = !is_even && new_value % test_division == 0


      # item.value = new_value.to_s[-1] if is_dividable

      # result = is_dividable

      # puts "#{item.value} (#{item.is_even}) (#{inspect_item(item.value)}): #{result}"

      # new_value = item.inspect(self)

      # result = new_value % test_division == 0

      new_value = inspect_item(item)

      result = new_value % test_division == 0

      if result
        item.value = Prime.prime_division(new_value).last.last + 1
      else
        item.value =  new_value
      end

      # item.last_division = test_division

      throw_to_monkey(test_conditions[result.to_s.to_sym], item)
    end

    @inspections += current_items.count
    @current_items = []
  end

  def throw_to_monkey(monkey_id, item)
    $monkeys[monkey_id].current_items << item
  end

  def inspect_item(item)
    level = eval(operation.gsub("old", item.value.to_s))

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

  # puts $monkeys.map { |m| m.id.to_s + ": " + m.current_items.map(&:inspect).join(', ') }.join(' | ')

  $monkeys.map { |monkey| monkey.inspections }.sort.last(2).reduce(&:*)
end

def part_2
  generate_rules(totally_relieved: true)

  20.times do |i|
    $monkeys.each do |monkey|
      a = Time.now
      monkey.play_round
      b = Time.now; puts "#{i}: #{b - a}" # (#{$monkeys.map { |a| a.current_items.join(',')}}"
    end
  end

  $monkeys.map { |monkey| monkey.inspections }#.sort#.last(2).reduce(&:*)
end

# puts part_1
puts part_2
