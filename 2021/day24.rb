#!/usr/bin/env ruby
require_relative 'day'
class Day24 < Day
  attr_accessor :cache
  # data is [], graph is {k => []}, f is {k => 0}, h is {}, result,r,c,x,y are ints
  def part1
    @cache = {}
    state = {
      w: 0, x: 0, y: 0, z: 0
    }.with_indifferent_access
    programs = self.input.split("\ninp ").map do |prog|
      (prog =~ /^inp/ ? prog : "inp #{prog}").lines.map do |line|
        cmd,var,val = *line.split(" ")
        val = val.to_i if val.present? && val =~ /-?\d+/
        [cmd,var,val]
      end
    end
    byebug
    states = [[state,0]]
    max = 0
    digits = (1..9).to_a.reverse.freeze
    programs.each_with_index do |program,pi|
      cache_name = "day24.p#{pi+1}.cache"
      if File.exist?(cache_name
        states = Marshal.load(File.binread(cache_name))}
        next
      end
      next_states = {}
      #enumerate all the outcome states of previous program
      # states = cache[pi-1] ? cache[pi-1].values.map{|h| h.except(:w)}.uniq : [state.dup]
      # byebug
      puts "P#{pi+1} trying #{states.size}"
      states.each do |state,prefix|
        digits.each do |digit|
          serial = prefix*10 + digit
          result = alu(program, digit, state)
          z = result[:z]
          if pi == programs.size - 1
            if z == 0 && serial > max
              max = serial
              puts "found new max serial #{serial}"
            end
          elsif z < 10_000_000 && (!next_states[z] || next_states[z].last < serial)
            next_states[z] = [result,serial]
          end
        end
      end
      states = next_states.values
      File.open(cache_name,"wb"){|f| f.write(Marshal.dump(states))}
    end

    byebug
    # (1..9).each do |digit|
    #   res = alu(programs[0..0],[digit],state.dup)
    #   puts "#{digit} ==> #{res}"
    # end
    # inputs = "13579246899999".chars.map(&:to_i)
    # result = alu(programs, inputs, state,{})

    # puts "13579246899999 ==> #{result}"
    # digits = []
    # cache = {}
    # programs.each_with_index do |program,i|
    #   #solve digit i
    #   state = {
    #     w: 0, x:0, y: 0, z: 0
    #   }.with_indifferent_access
    #   9.downto(1) do |num|
    #     inputs = digits + [num]
    #     inputs = "13579246899999".chars
    #     result = alu(programs, inputs, state)
    #     puts "result of program#{i} with #{num} => #{result}"
    #     if result[:z] == 0
    #       digits << num
    #       break
    #     end
    #   end
    # end
    # puts "solved #{digits.join}"
  end

  def alu(program,input,state)
    input_num = 0
    state = state.dup
    # expr_state = state.dup
    # program_cache[[state.except(:w),input]] ||= begin
    # programs.each_with_index do |program,pi|
      program.each_with_index do |(cmd,var,val),li|
        
        # expr_val = val
        if val.present?
          # expr_val = expr_val =~ /-?\d+/ ? expr_val.to_i : expr_state[expr_val]
          val = val.is_a?(Numeric) ? val : state[val]
        end
        # printf("P%2d L%2d %-10s %14s w=%10d x=%10d y=%10d z=%10d", pi, li, line, inputs.join, *state.values)
        # if !state[var].is_a?(Numeric) || val.is_a?(String)
        #   byebug
        # end
        case cmd
        when 'inp'
          # inp a - Read an input value and write it to variable a.
          state[var] = input.to_i
          # expr_state[var] = "inputs[#{pi}]"
        when 'add'
          # add a b - Add the value of a to the value of b, then store the result in variable a.
          state[var] += val
          # add y w
          # if line == "add y w"
          #   byebug
          # end
          # if expr_state[var] == 0
          #   expr_state[var] = expr_val
          # elsif expr_val != 0
          #   expr_state[var] ="(#{expr_state[var]}+#{expr_val})"
          # end
          # end
        when 'mul'
          state[var] = (state[var] * val)
          # if expr_val != 1
          #   expr_state[var] ="(#{expr_state[var]}*#{expr_val})"
          # end
        when 'div'
          state[var] = (state[var] / val).floor
          # if expr_val != 1
          #   expr_state[var] ="(#{expr_state[var]}/#{expr_val})"
          # end
        when 'mod'
          state[var] = (state[var] % val)
          # if expr_val != 1 && expr_state[var] != 0
          #   expr_state[var] = "(#{expr_state[var]} % #{expr_val})"
          # end
        when 'eql'
          # expr_state[var] ="(#{expr_state[var]} == #{expr_val} ? 1 : 0)"
          # if (val > 10 && expr_state[var].scan(/inputs/).size <= 1)
          #   # byebug
          #   expr_state[var] = eval(expr_state[var])
          # elsif (state[var] > 10 && expr_val.scan(/inputs/).size <= 1)
          #   expr_state[var] = eval(expr_state[var])
          # end
          state[var] = (state[var] == val ? 1 : 0)
        else
          raise "invalid: #{line}"
        end
        # if expr_state[var] !~ /inputs/
        #   # byebug
        #   expr_state[var] = eval(expr_state[var].to_s)
        # end
        # puts "P#{pi} L#{li}: #{line} expr_state: #{expr_state}"
        # printf(" ==> w=%10d x=%10d y=%10d z=%10d\n",*state.values)
      end
    # end
    # [state,expr_state]
    state
  end

end
if __FILE__ == $0
  ENV["INPUT"] = ARGV.last || __FILE__.split("/").last.gsub(".rb",'')
  Day24.new.part1
end

=begin
## --- Day 24: Arithmetic Logic Unit ---[Magic smoke](https://en.wikipedia.org/wiki/Magic_smoke "") starts leaking from the submarine's [arithmetic logic unit](https://en.wikipedia.org/wiki/Arithmetic_logic_unit "") (ALU). Without the ability to perform basic arithmetic and logic functions, the submarine can't produce cool patterns with its Christmas lights!

It also can't navigate. Or run the oxygen system.

Don't worry, though - you *probably* have enough oxygen left to give you enough time to build a new ALU.

The ALU is a four-dimensional processing unit: it has integer variables `w`, `x`, `y`, and `z`. These variables all start with the value `0`. The ALU also supports *six instructions*:

* `inp a` - Read an input value and write it to variable `a`.
* `add a b` - Add the value of `a` to the value of `b`, then store the result in variable `a`.
* `mul a b` - Multiply the value of `a` by the value of `b`, then store the result in variable `a`.
* `div a b` - Divide the value of `a` by the value of `b`, truncate the result to an integer, then store the result in variable `a`. (Here, "truncate" means to round the value toward zero.)
* `mod a b` - Divide the value of `a` by the value of `b`, then store the *remainder* in variable `a`. (This is also called the [modulo](https://en.wikipedia.org/wiki/Modulo_operation "") operation.)
* `eql a b` - If the value of `a` and `b` are equal, then store the value `1` in variable `a`. Otherwise, store the value `0` in variable `a`.

In all of these instructions, `a` and `b` are placeholders; `a` will always be the variable where the result of the operation is stored (one of `w`, `x`, `y`, or `z`), while `b` can be either a variable or a number. Numbers can be positive or negative, but will always be integers.

The ALU has no *jump* instructions; in an ALU program, every instruction is run exactly once in order from top to bottom. The program halts after the last instruction has finished executing.

(Program authors should be especially cautious; attempting to execute `div` with `b=0` or attempting to execute `mod` with `a&lt;0` or `b&lt;=0`  will cause the program to crash and might even damage the ALU. These operations are never intended in any serious ALU program.)

For example, here is an ALU program which takes an input number, negates it, and stores it in `x`:

```
inp x
mul x -1
```

Here is an ALU program which takes two input numbers, then sets `z` to `1` if the second input number is three times larger than the first input number, or sets `z` to `0` otherwise:

```
inp z
inp x
mul z 3
eql z x
```

Here is an ALU program which takes a non-negative integer as input, converts it into binary, and stores the lowest (1's) bit in `z`, the second-lowest (2's) bit in `y`, the third-lowest (4's) bit in `x`, and the fourth-lowest (8's) bit in `w`:

```
inp w
add z w
mod z 2
div w 2
add y w
mod y 2
div w 2
add x w
mod x 2
div w 2
mod w 2
```

Once you have built a replacement ALU, you can install it in the submarine, which will immediately resume what it was doing when the ALU failed: validating the submarine's *model number*. To do this, the ALU will run the MOdel Number Automatic Detector program (MONAD, your puzzle input).

Submarine model numbers are always *fourteen-digit numbers* consisting only of digits `1` through `9`. The digit `0` *cannot* appear in a model number.

When MONAD checks a hypothetical fourteen-digit model number, it uses fourteen separate `inp` instructions, each expecting a *single digit* of the model number in order of most to least significant. (So, to check the model number `13579246899999`, you would give `1` to the first `inp` instruction, `3` to the second `inp` instruction, `5` to the third `inp` instruction, and so on.) This means that when operating MONAD, each input instruction should only ever be given an integer value of at least `1` and at most `9`.

Then, after MONAD has finished running all of its instructions, it will indicate that the model number was *valid* by leaving a `0` in variable `z`. However, if the model number was *invalid*, it will leave some other non-zero value in `z`.

MONAD imposes additional, mysterious restrictions on model numbers, and legend says the last copy of the MONAD documentation was eaten by a [tanuki](https://en.wikipedia.org/wiki/Japanese_raccoon_dog ""). You'll need to *figure out what MONAD does* some other way.

To enable as many submarine features as possible, find the largest valid fourteen-digit model number that contains no `0` digits. *What is the largest model number accepted by MONAD?*
=end
