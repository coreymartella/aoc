accumulator = 0
instructions = File.readlines("data/p08.txt").map(&:strip)
original_instructions = File.readlines("data/p08.txt").map(&:strip)
line = 0
executed = []
resets = []
while line <= instructions.size - 1 do
  raw = instructions[line].strip
  # puts "line=#{line} raw=#{raw} accumulator=#{accumulator}"
  instruction, delta = raw.split(/ \+?/)
  delta = delta.to_i

  if repeat = executed.index(line)
    cause = executed.reverse.detect do |prev|
      !instructions[prev]["acc"] && !resets.include?(prev)
    end

    raw_cause = original_instructions[cause]
    new_raw_cause = raw_cause["nop"] ? raw_cause.gsub("nop","jmp") : raw_cause.gsub("jmp","nop")
    instructions = original_instructions.map(&:dup)
    instructions[cause] = new_raw_cause

    puts "found loop at #{line} caused by #{cause} #{raw_cause} ==> #{new_raw_cause}"

    line = 0
    accumulator = 0
    executed = []
    resets << cause
    next
  end

  executed << line
  if instruction == "acc"
    accumulator += delta
  end
  line = line + (instruction == "jmp" ? delta : 1)
end
puts "accumulator #{accumulator}"
