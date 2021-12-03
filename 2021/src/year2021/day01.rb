module Year2021
  class Day01
    def part1(input)
      lines = input.split("\n").map(&:to_i)

      increases = 0
      lines.each_with_index do |line,i|
        prev = i > 0 ? lines[i-1] : nil
        if prev && prev < line
          increases += 1
        end
      end
      increases
    end

    def part2(input)
      lines = input.split("\n").map(&:to_i)

      increases = 0
      lines.each_with_index do |line,i|

        prev = i >= 3 ? lines[i-3..i-1].sum : nil
        curr = i >= 2 ? lines[i-2..i].sum : nil

        if prev && curr && prev < curr
          increases += 1
        end
      end
      increases
    end
  end
end
