class CPU
  attr_reader :instructions, :registers, :cycle, :snapshots, :take_snapshots

  def initialize(take_snapshots: false)
    # I thought there would be more registers, so I did it that way...
    @registers = [{ name: 'X', value: 1 }]
    @instructions = File.read("input.txt").split("\n")
    @cycle = 0
    @snapshots = []
    @take_snapshots = take_snapshots
  end

  def run
    while @instructions.count > 0
      process_new_instruction(@instructions.shift)
    end
  end

  def compute_snapshots_values
    snapshots.sum { |snapshot| snapshot[:value].first[:value] * snapshot[:at] }
  end

  private

  def process_new_instruction(instruction)
    parts = instruction.split(' ')

    send("process_#{parts.first}".to_sym, parts[1..-1])
  end

  def process_noop(_)
    after_cycles(1) {}
  end

  def process_addx(args)
    after_cycles(2) { add_value_to_register('X', args.first.to_i) }
  end

  def add_value_to_register(name, value)
    @registers.find { |r| r[:name] == name }[:value] += value
  end

  def after_cycles(nb, &block)
    nb.times do
      during_cycle_hook
      @cycle += 1

      snapshot_registers if should_snapshot_registers?
    end

    block.call
  end

  def during_cycle_hook; end

  def should_snapshot_registers?
    take_snapshots && [20, 60, 100, 140, 180, 220].include?(cycle)
  end

  def snapshot_registers
    @snapshots << { at: cycle, value: registers.map { |r| r.dup } }
  end
end

class CRT < CPU
  def initialize
    @pixels = '.' * (6 * 40)

    super
  end

  def during_cycle_hook
    actual_position = sprite_position + 40 * (cycle / 40)

    @pixels[cycle] = '#' if (actual_position - 1..actual_position + 1).include?(cycle)
  end

  def display_crt
    puts @pixels.chars.each_slice(40).map { |chars| chars.join }.join("\n")
  end

  def sprite_position
    registers.first[:value]
  end
end


def part_1
  cpu = CPU.new(take_snapshots: true)
  cpu.run

  cpu.compute_snapshots_values
end

def part_2
  crt = CRT.new

  crt.run
  crt.display_crt
end


puts part_1

part_2
