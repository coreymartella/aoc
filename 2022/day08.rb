#!/usr/bin/env ruby
require_relative 'day'
class Day08 < Day
  # data is [], graph is {k => []}, f is {k => 0}, h is {}, answer,r,c,x,y are ints
  def part1
    # debug!
    #
    # v1, v2 = *input.split("\n\n")
    each_line do |line, r|
      graph[r] = line.chars.map(&:to_i) if line.strip.present?
    end
    graph.each do |r, row|
      if r == 0 || r == graph.size - 1
        self.answer += row.size
        next
      end

      row.each_with_index do |col, c|
        if c == 0 || c == row.size - 1
          self.answer += 1
          next
        end
        visible = (c-1).downto(0).all? {|i| row[i] < col}
        visible ||= (c+1).upto(row.size-1).all? {|i| row[i] < col}
        visible ||= (r-1).downto(0).all? {|i| graph[i][c] < col}
        visible ||= (r+1).upto(graph.size-1).all? {|i| graph[i][c] < col}
        @answer += 1 if visible
      end
    end
    # max_iters = 10
    # 1.upto(max_iters) do |iter|
    #
    # end

    puts "Answer is #{answer}... Submitting..."
    submit_answer(part: 1, answer: answer)
  end

  def part2
    each_line do |line, r|
      graph[r] = line.chars.map(&:to_i) if line.strip.present?
    end
    graph.each do |r, row|
      row.each_with_index do |val, c|
        vis_l = c == 0 ? 0 : (c-1).downto(0).reduce(0) do |count, i|
          count += 1
          break(count) if row[i] >= val
          count
        end
        vis_r ||= (c+1).upto(row.size-1).reduce(0) do |count, i|
          count += 1
          break(count) if row[i] >= val
          count
        end
        vis_u ||= (r-1).downto(0).reduce(0) do |count, i|
          count += 1
          break(count) if graph[i][c] >= val
          count
        end
        vis_d ||= (r+1).upto(graph.size-1).reduce(0) do |count, i|
          count += 1
          break(count) if graph[i][c] >= val
          count
        end
        @answer = [@answer, vis_l * vis_r * vis_u * vis_d].compact.max
      end
    end
    puts "Answer is #{answer}"
    # submit_answer(part: 2, answer: answer)
  end
end
if __FILE__ == $0
  ENV["INPUT"] = ARGV.last || __FILE__.split("/").last.gsub(".rb",'')
  d = Day08.new
  d.respond_to?(:part2) ? d.part2 : d.part1
end

=begin
## --- Day 8: Treetop Tree House ---The expedition comes across a peculiar patch of tall trees all planted carefully in a grid. The Elves explain that a previous expedition planted these trees as a reforestation effort. Now, they're curious if this would be a good location for a [tree house](https://en.wikipedia.org/wiki/Tree_house "").

First, determine whether there is enough tree cover here to keep a tree house *hidden*. To do this, you need to count the number of trees that are *visible from outside the grid* when looking directly along a row or column.

The Elves have already launched a [quadcopter](https://en.wikipedia.org/wiki/Quadcopter "") to generate a map with the height of each tree (your puzzle input). For example:

```
30373
25512
65332
33549
35390
```

Each tree is represented as a single digit whose value is its height, where `0` is the shortest and `9` is the tallest.

A tree is *visible* if all of the other trees between it and an edge of the grid are *shorter* than it. Only consider trees in the same row or column; that is, only look up, down, left, or right from any given tree.

All of the trees around the edge of the grid are *visible* - since they are already on the edge, there are no trees to block the view. In this example, that only leaves the *interior nine trees* to consider:

* The top-left `5` is *visible* from the left and top. (It isn't visible from the right or bottom since other trees of height `5` are in the way.)
* The top-middle `5` is *visible* from the top and right.
* The top-right `1` is not visible from any direction; for it to be visible, there would need to only be trees of height *0* between it and an edge.
* The left-middle `5` is *visible*, but only from the right.
* The center `3` is not visible from any direction; for it to be visible, there would need to be only trees of at most height `2` between it and an edge.
* The right-middle `3` is *visible* from the right.
* In the bottom row, the middle `5` is *visible*, but the `3` and `4` are not.

With 16 trees visible on the edge and another 5 visible in the interior, a total of `*21*` trees are visible in this arrangement.

Consider your map; *how many trees are visible from outside the grid?*
=end
