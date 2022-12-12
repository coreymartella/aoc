#!/usr/bin/env ruby
require_relative 'day'
class Day10 < Day
  # data is [], graph is {k => []}, f is {k => 0}, h is {}, answer,r,c,x,y are ints
  attr_accessor :cycle, :pixels
  def part1
    # debug!
    #
    # v1, v2 = *input.split("\n\n")
    @cycle = 1
    self.x = 1
    self.pixels = []
    each_line do |line, li|
      if line =~ /noop/
        incr_answer
        draw_pixel
        @cycle += 1
      elsif (val = line[/addx (-?\d+)/, 1])
        # debugger
        incr_answer
        draw_pixel
        @cycle += 1

        incr_answer
        draw_pixel
        @cycle += 1

        self.x += val.to_i
      end
    end
    incr_answer
    draw_pixel
    puts pixels if pixels.any?
    puts "Answer is #{answer}"
    # submit_answer(part: 1, answer: answer) unless ARGV.join.include?('.ex')
  end

  def incr_answer
    # print "line=#{line} cycle=#{cycle} x=#{x}"
    if cycle % 40 == 20
      # puts " INCR by #{cycle * x}, #{answer} ==> #{answer + cycle * x}"
      self.answer += cycle * x
    else
      # puts ""
    end
  end

  def draw_pixel
    sprite_position = (cycle-1) % 40
    if (sprite_position-x).abs <= 1
      pixels << '#'
    else
      pixels << '.'
    end
    if pixels.size == 40
      puts pixels.join
      self.pixels = []
    end
  end
  # def part2
  #   # debug!
  #   puts "Answer is #{answer}"
  #   submit_answer(part: 2, answer: answer) unless ARGV.join.include?('.ex')
  # end
end
if __FILE__ == $0
  ENV["INPUT"] = ARGV.last || __FILE__.split("/").last.gsub(".rb",'')
  d = Day10.new
  d.respond_to?(:part2) ? d.part2 : d.part1
end

=begin
## --- Day 10: Cathode-Ray Tube ---You avoid the ropes, plunge into the river, and swim to shore.

The Elves yell something about meeting back up with them upriver, but the river is too loud to tell exactly what they're saying. They finish crossing the bridge and disappear from view.

Situations like this must be why the Elves prioritized getting the communication system on your handheld device working. You pull it out of your pack, but the amount of water slowly draining from a big crack in its screen tells you it probably won't be of much immediate use.

*Unless*, that is, you can design a replacement for the device's video system! It seems to be some kind of [cathode-ray tube](https://en.wikipedia.org/wiki/Cathode-ray_tube "") screen and simple CPU that are both driven by a precise *clock circuit*. The clock circuit ticks at a constant rate; each tick is called a *cycle*.

Start by figuring out the signal being sent by the CPU. The CPU has a single register, `X`, which starts with the value `1`. It supports only two instructions:

* `addx V` takes *two cycles* to complete. *After* two cycles, the `X` register is increased by the value `V`. (`V` can be negative.)
* `noop` takes *one cycle* to complete. It has no other effect.

The CPU uses these instructions in a program (your puzzle input) to, somehow, tell the screen what to draw.

Consider the following small program:

```
noop
addx 3
addx -5
```

Execution of this program proceeds as follows:

* At the start of the first cycle, the `noop` instruction begins execution. During the first cycle, `X` is `1`. After the first cycle, the `noop` instruction finishes execution, doing nothing.
* At the start of the second cycle, the `addx 3` instruction begins execution. During the second cycle, `X` is still `1`.
* During the third cycle, `X` is still `1`. After the third cycle, the `addx 3` instruction finishes execution, setting `X` to `4`.
* At the start of the fourth cycle, the `addx -5` instruction begins execution. During the fourth cycle, `X` is still `4`.
* During the fifth cycle, `X` is still `4`. After the fifth cycle, the `addx -5` instruction finishes execution, setting `X` to `-1`.

Maybe you can learn something by looking at the value of the `X` register throughout execution. For now, consider the *signal strength* (the cycle number multiplied by the value of the `X` register) *during* the 20th cycle and every 40 cycles after that (that is, during the 20th, 60th, 100th, 140th, 180th, and 220th cycles).

For example, consider this larger program:

```
addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop
```

The interesting signal strengths can be determined as follows:

* During the 20th cycle, register `X` has the value `21`, so the signal strength is 20 * 21 = *420*. (The 20th cycle occurs in the middle of the second `addx -1`, so the value of register `X` is the starting value, `1`, plus all of the other `addx` values up to that point: 1 + 15 - 11 + 6 - 3 + 5 - 1 - 8 + 13 + 4 = 21.)
* During the 60th cycle, register `X` has the value `19`, so the signal strength is 60 * 19 = `*1140*`.
* During the 100th cycle, register `X` has the value `18`, so the signal strength is 100 * 18 = `*1800*`.
* During the 140th cycle, register `X` has the value `21`, so the signal strength is 140 * 21 = `*2940*`.
* During the 180th cycle, register `X` has the value `16`, so the signal strength is 180 * 16 = `*2880*`.
* During the 220th cycle, register `X` has the value `18`, so the signal strength is 220 * 18 = `*3960*`.

The sum of these signal strengths is `*13140*`.

Find the signal strength during the 20th, 60th, 100th, 140th, 180th, and 220th cycles. *What is the sum of these six signal strengths?*
=end
