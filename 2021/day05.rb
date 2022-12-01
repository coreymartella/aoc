class Day05 < Day
  def part1
    debug!
    counts = Hash.new(0)
    lines.each_with_index do |line,linenum|
      x1,y1,x2,y2 = *line.scan(/(\d+),(\d+) -> (\d+),(\d+)/).flatten.map(&:to_i)
      if x1 == x2
        r = y1 < y2 ? (y1..y2) : (y2..y1)
        r.each do |y|
          counts[[x1,y]] += 1
        end
      elsif y1 == y2
        r = x1 < x2 ? (x1..x2) : (x2..x1)
        r.each do |x|
          counts[[x,y1]] += 1
        end
      else
        next "non standard line #{line}"
      end
      print_counts(counts)
    end
    xmax = counts.keys.map(&:first).max
    ymax = counts.keys.map(&:last).max
    # puts "grid is #{xmax},#{ymax}"
    bad_count = 0
    0.upto(xmax) do |x|
      0.upto(ymax) do |y|
        bad_count += 1 if counts[[x,y]] >= 2
      end
    end
    bad_count
  end

  def part2(input)
    counts = Hash.new(0)
    lines.each_with_index do |line,linenum|
      x1,y1,x2,y2 = *line.scan(/(\d+),(\d+) -> (\d+),(\d+)/).flatten.map(&:to_i)
      if x1 == x2
        puts "\nV line #{line}"
        r = y1 < y2 ? (y1..y2) : (y2..y1)
        r.each do |y|
          # puts "\n incr #{x1},#{y}"
          counts[[x1,y]] += 1
        end
      elsif y1 == y2
        r = x1 < x2 ? (x1..x2) : (x2..x1)
        puts "\nH line #{line}"
        r.each do |x|
          counts[[x,y1]] += 1
        end
      elsif (y1-y2).abs == (x1-x2).abs
        puts "\n45 line #{line}"
        if x1 < x2 && y1 < y2
          xs = (x1..x2).to_a
          ys = (y1..y2).to_a
        elsif x1 < x2 && y1 > y2
          xs = (x1..x2).to_a
          ys = (y2..y1).to_a.reverse
        elsif x1 > x2 && y1 < y2
          xs = (x2..x1).to_a.reverse
          ys = (y1..y2).to_a
        elsif x1 > x2 && y1 > y2
          xs = (x2..x1).to_a
          ys = (y2..y1).to_a
        end
        xs.each_with_index do |x,i|
          counts[[x,ys[i]]] += 1
        end
      else
        next "non standard line #{line}"
      end
      # print_counts(counts)
    end
    xmax = counts.keys.map(&:first).max
    ymax = counts.keys.map(&:last).max
    # puts "grid is #{xmax},#{ymax}"
    bad_count = 0
    0.upto(xmax) do |x|
      0.upto(ymax) do |y|
        bad_count += 1 if counts[[x,y]] >= 2
      end
    end
    bad_count
  end

  def print_counts(counts)
    xmax = 9 #counts.keys.map(&:first).max
    ymax = 9 #counts.keys.map(&:last).max
    0.upto(ymax) do |y|
      0.upto(xmax) do |x|
        print counts[[x,y]] == 0 ? "." : counts[[x,y]]
      end
      puts
    end
    puts
    puts
  end
end

=begin
## --- Day 5: Hydrothermal Venture ---You come across a field of [hydrothermal vents](https://en.wikipedia.org/wiki/Hydrothermal_vent "") on the ocean floor! These vents constantly produce large, opaque clouds, so it would be best to avoid them if possible.

They tend to form in *lines*; the submarine helpfully produces a list of nearby lines of vents (your puzzle input) for you to review. For example:

```
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
```

Each line of vents is given as a line segment in the format `x1,y1 -> x2,y2` where `x1`,`y1` are the coordinates of one end the line segment and `x2`,`y2` are the coordinates of the other end. These line segments include the points at both ends. In other words:

* An entry like `1,1 -> 1,3` covers points `1,1`, `1,2`, and `1,3`.
* An entry like `9,7 -> 7,7` covers points `9,7`, `8,7`, and `7,7`.

For now, *only consider horizontal and vertical lines*: lines where either `x1 = x2` or `y1 = y2`.

So, the horizontal and vertical lines from the above list would produce the following diagram:

```
.......1..
..1....1..
..1....1..
.......1..
.112111211
..........
..........
..........
..........
222111....
```

In this diagram, the top left corner is `0,0` and the bottom right corner is `9,9`. Each position is shown as *the number of lines which cover that point* or `.` if no line covers that point. The top-left pair of `1`s, for example, comes from `2,2 -> 2,1`; the very bottom row is formed by the overlapping lines `0,9 -> 5,9` and `0,9 -> 2,9`.

To avoid the most dangerous areas, you need to determine *the number of points where at least two lines overlap*. In the above example, this is anywhere in the diagram with a `2` or larger - a total of `*5*` points.

Consider only horizontal and vertical lines. *At how many points do at least two lines overlap?*
=end
