#!/usr/bin/env ruby
require_relative 'day'
class Day12 < Day
  # data is [], graph is {k => []}, f is {k => 0}, h is {}, answer,r,c,x,y are ints
  attr_accessor :s, :e
  def part1
    # debug!
    #
    # v1, v2 = *input.split("\n\n")

    each_line do |line, y|
      graph[y] = line.chars.map.with_index do |c,x|
        if c == 'S'
          @s = Point.new(x, y)
          0
        elsif c == 'E'
          @e = Point.new(x, y)
          'z'.ord - 'a'.ord
        else
          c.ord - 'a'.ord
        end
      end
    end
    unvisited = graph.keys.product((0..graph[0].size-1).to_a).filter_map do |y,x|
      (p = Point.new(x, y)) == s ? nil : p
    end.to_set.sort_by{|p| s.manhattan(p)}
    dist = Hash.new(INFINITY)
    curr = s
    dist[curr] = 0
    puts "checking #{graph.values.first.size} x #{graph.size}"
    while unvisited.any?
      [-1,0,1].each do |yoff|
        [-1,0,1].each do |xoff|
          next if yoff != 0 && xoff != 0
          next if yoff == 0 && xoff == 0

          next if curr.y+yoff < 0 || curr.y+yoff >= graph.size
          next if curr.x+xoff < 0 || curr.x+xoff >= graph[0].size

          h = graph[curr.y][curr.x]
          next_h = graph[curr.y+yoff][curr.x+xoff]
          next if next_h > h + 1

          node = Point.new(curr.x + xoff, curr.y + yoff)
          # debugger
          puts "#{curr} checking #{node} dist is #{dist[node]} vs #{dist[curr]} + #{graph[node.y][node.x]}"
          dist[node] = [dist[node], dist[curr] + 1].min
        end
      end
      unvisited.delete(curr)
      # debugger
      curr = unvisited.min_by{|n| dist[n]}
    end

    self.answer = dist[e]

    puts "Answer is #{answer}"
    submit_answer(part: 1, answer: answer) unless ARGV.join.include?('.ex')
  end

  def part2
each_line do |line, y|
  graph[y] = line.chars.map.with_index do |c,x|
    if c == 'S'
      @s = Point.new(x, y)
      0
    elsif c == 'E'
      @e = Point.new(x, y)
      'z'.ord - 'a'.ord
    else
      c.ord - 'a'.ord
    end
  end
end
unvisited = graph.keys.product((0..graph[0].size-1).to_a).filter_map do |y,x|
  p = Point.new(x, y)
end.to_set.sort_by{|p| graph[p.y][p.x]}
dist = Hash.new(INFINITY)
unvisited.select{|p| graph[p.y][p.x] == 0}.each do |p|
  dist[p] = 0
end
curr = unvisited.shift
puts "checking #{graph.values.first.size} x #{graph.size}"
while unvisited.any?
  [-1,0,1].each do |yoff|
    [-1,0,1].each do |xoff|
      next if yoff != 0 && xoff != 0
      next if yoff == 0 && xoff == 0

      next if curr.y+yoff < 0 || curr.y+yoff >= graph.size
      next if curr.x+xoff < 0 || curr.x+xoff >= graph[0].size

      h = graph[curr.y][curr.x]
      next_h = graph[curr.y+yoff][curr.x+xoff]
      next if next_h > h + 1

      node = Point.new(curr.x + xoff, curr.y + yoff)
      # debugger
      # puts "#{curr} checking #{node} dist is #{dist[node]} vs #{dist[curr]} + #{graph[node.y][node.x]}"
      dist[node] = [dist[node], dist[curr] + 1].min
    end
  end
  unvisited.delete(curr)
  # debugger
  curr = unvisited.min_by{|n| dist[n]}
end

self.answer = dist[e]

puts "Answer is #{answer}"
submit_answer(part: 2, answer: answer) unless ARGV.join.include?('.ex')  end
end
if __FILE__ == $0
  ENV["INPUT"] = ARGV.last || __FILE__.split("/").last.gsub(".rb",'')
  d = Day12.new
  d.respond_to?(:part2) ? d.part2 : d.part1
end

=begin
## --- Day 12: Hill Climbing Algorithm ---You try contacting the Elves using your handheld device, but the river you're following must be too low to get a decent signal.

You ask the device for a heightmap of the surrounding area (your puzzle input). The heightmap shows the local area from above broken into a grid; the elevation of each square of the grid is given by a single lowercase letter, where `a` is the lowest elevation, `b` is the next-lowest, and so on up to the highest elevation, `z`.

Also included on the heightmap are marks for your current position (`S`) and the location that should get the best signal (`E`). Your current position (`S`) has elevation `a`, and the location that should get the best signal (`E`) has elevation `z`.

You'd like to reach `E`, but to save energy, you should do it in *as few steps as possible*. During each step, you can move exactly one square up, down, left, or right. To avoid needing to get out your climbing gear, the elevation of the destination square can be *at most one higher* than the elevation of your current square; that is, if your current elevation is `m`, you could step to elevation `n`, but not to elevation `o`. (This also means that the elevation of the destination square can be much lower than the elevation of your current square.)

For example:

```
*S*abqponm
abcryxxl
accsz*E*xk
acctuvwj
abdefghi
```

Here, you start in the top-left corner; your goal is near the middle. You could start by moving down or right, but eventually you'll need to head toward the `e` at the bottom. From there, you can spiral around to the goal:

```
v..v&lt;&lt;&lt;&lt;
&gt;v.vv&lt;&lt;^
.&gt;vv&gt;E^^
..v&gt;&gt;&gt;^^
..&gt;&gt;&gt;&gt;&gt;^
```

In the above diagram, the symbols indicate whether the path exits each square moving up (`^`), down (`v`), left (`&lt;`), or right (`&gt;`). The location that should get the best signal is still `E`, and `.` marks unvisited squares.

This path reaches the goal in `*31*` steps, the fewest possible.

*What is the fewest steps required to move from your current position to the location that should get the best signal?*
=end
