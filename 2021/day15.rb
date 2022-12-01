class Day15 < Day
  # data is [], graph is {k => []}, f is {k => 0}, h is {}, result,r,c,x,y are ints
  INFINITY = 1 << 64

  def part1
    # debug!
    #
    # v1, v2 = *input.split("")
    @graph = graph
    each_line do |line, y|
      line.chars.each_with_index do |c,x|
        graph[y][x] = c.to_i
      end
    end

    <<-ALGO
    Mark all nodes unvisited. Create a set of all the unvisited nodes called the unvisited set.
    Assign to every node a tentative distance value: set it to zero for our initial node and to infinity for all other nodes. The tentative distance of a node v is the length of the shortest path discovered so far between the node v and the starting node. Since initially no path is known to any other vertex than the source itself (which is a path of length zero), all other tentative distances are initially set to infinity. Set the initial node as current.[15]
    For the current node, consider all of its unvisited neighbors and calculate their tentative distances through the current node. Compare the newly calculated tentative distance to the current assigned value and assign the smaller one. For example, if the current node A is marked with a distance of 6, and the edge connecting it with a neighbor B has length 2, then the distance to B through A will be 6 + 2 = 8. If B was previously marked with a distance greater than 8 then change it to 8. Otherwise, the current value will be kept.
    When we are done considering all of the unvisited neighbors of the current node, mark the current node as visited and remove it from the unvisited set. A visited node will never be checked again.
    If the destination node has been marked visited (when planning a route between two specific nodes) or if the smallest tentative distance among the nodes in the unvisited set is infinity (when planning a complete traversal; occurs when there is no connection between the initial node and remaining unvisited nodes), then stop. The algorithm has finished.
    Otherwise, select the unvisited node that is marked with the smallest tentative distance, set it as the new current node, and go back to step 3.
    ALGO
    unvisited = ((0..graph.size-1).to_a.product (0..graph.size-1).to_a).map{|x,y| {x: x, y: y}}.to_set
    dist = Hash.new(INFINITY)
    curr = {x: 0, y: 0}
    dist[curr] = 0
    puts! "checking #{graph.size} x #{graph.values.first.size}"
    while unvisited.any?
      next_curr = nil
      min_next = INFINITY
      [-1,0,1].each do |yoff|
        [-1,0,1].each do |xoff|
          next if yoff != 0 && xoff != 0
          next if yoff == 0 && xoff == 0

          next if curr[:y]+yoff < 0 || curr[:y]+yoff >= graph.size
          next if curr[:x]+xoff < 0 || curr[:x]+xoff >= graph.size

          node = {x: curr[:x] + xoff, y: curr[:y] + yoff}
          # puts!{ "#{curr} checking #{node} dist is #{dist[node]} vs #{dist[curr]} + #{graph[node[:y]][node[:x]]}"}
          dist[node] = [dist[node], dist[curr] + graph[node[:y]][node[:x]]].min
        end
      end
      unvisited.delete(curr)
      curr = unvisited.min_by{|n| dist[n]}
    end

    dist[{x: graph.size-1, y: graph.size-1}]
  end

  Node = Struct.new(:x,:y,:w,:dist,:queued)
  def part2
    # debug!
    each_line do |line, y|
      line.chars.each_with_index do |c,x|
        graph[[x,y]] = Node.new(x, y, c.to_i, x==0 && y==0 ? 0 : INFINITY,false)
      end
    end
    @tile_size_x = @graph.keys.map(&:first).max + 1
    @tile_size_y = @graph.keys.map(&:last).max + 1
    @graph_size_x = @tile_size_x*5
    @graph_size_y = @tile_size_y*5
    @graph.default_proc = ->(h,k) {
      n = k.first < @tile_size_x ? h[[k.first, k.last - @tile_size_y]] : h[[k.first - @tile_size_y, k.last]]
      h[k] = Node.new(k.first,k.last,(n.w == 9 ? 1 : n.w + 1), INFINITY,false)
    }

    puts! "checking #{@tile_size_x}x#{@tile_size_y} tiles on a #{@graph_size_x}x#{@graph_size_y} graph"
    # prev = {}
    s = graph[[0,0]]
    s.queued = true
    queue = []
    queue << s
    while curr = queue.shift
      curr.queued = false
      print!("\r %3d,%3d queue_size=%4d DIST=#{curr.dist}" % [curr.x,curr.y,queue.size])
      [[-1,0],[1,0],[0,-1],[0,1]].each do |xoff,yoff|
        next if curr.x+xoff < 0 || curr.x+xoff >= @graph_size_x
        next if curr.y+yoff < 0 || curr.y+yoff >= @graph_size_y

        node = graph[[curr.x + xoff, curr.y + yoff]]
        new_dist = curr.dist + node.w
        if new_dist < node.dist
          # puts "  found better for #{node.x},#{node.y} #{node.dist} vs #{new_dist}"
          node.dist = new_dist
          # requeue by removing it from the queue
          if node.queued
            queue.delete_at(queue.index(node))
          end
          node.queued = true
          if queue.empty? || node.dist >= queue.last.dist
            queue << node
          else
            insert_at = queue.bsearch_index { |o| o.dist >= node.dist }
            queue.insert(insert_at, node)
          end
        end
      end
    end
    puts!
    puts!
    graph[[@graph_size_x-1, @graph_size_y-1]].dist
  end
end
=begin
## --- Day 15: Chiton ---You've almost reached the exit of the cave, but the walls are getting closer together. Your submarine can barely still fit, though; the main problem is that the walls of the cave are covered in [chitons](https://en.wikipedia.org/wiki/Chiton ""), and it would be best not to bump any of them.

The cavern is large, but has a very low ceiling, restricting your motion to two dimensions. The shape of the cavern resembles a square; a quick scan of chiton density produces a map of *risk level* throughout the cave (your puzzle input). For example:

```
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
```

You start in the top left position, your destination is the bottom right position, and you cannot move diagonally. The number at each position is its *risk level*; to determine the total risk of an entire path, add up the risk levels of each position you *enter* (that is, don't count the risk level of your starting position unless you enter it; leaving it adds no risk to your total).

Your goal is to find a path with the *lowest total risk*. In this example, a path with the lowest total risk is highlighted here:

```
*1*163751742
*1*381373672
*2136511*328
369493*15*69
7463417*1*11
1319128*13*7
13599124*2*1
31254216*3*9
12931385*21*
231194458*1*
```

121365111511323211
The total risk of this path is `*40*` (the starting position is never entered, so its risk is not counted).

*What is the lowest total risk of any path from the top left to the bottom right?*
=end


class MinHeap
    # Implement a MinHeap using an array
    def initialize
        # Initialize arr with nil as first element
        # This dummy element makes it where first real element is at index 1
        # You can now divide i / 2 to find an element's parent
        # Elements' children are at i * 2 && (i * 2) + 1
        @elements = [nil]
    end

    def min
        @elements[1..-1].min_by(&:dist)
    end

    def <<(element)
        # push item onto end (bottom) of heap
        @elements.push(element)
        # then bubble it up until it's in the right spot
        bubble_up(@elements.length - 1)
    end

    def pop
        # swap the first and last elements
        @elements[1], @elements[@elements.length - 1] = @elements[@elements.length - 1], @elements[1]
        # Min element is now at end of arr (bottom of heap)
        min = @elements.pop
        # Now bubble the top element (previously the bottom element) down until it's in the correct spot
        bubble_down(1)
        # return the min element
        min
    end

    def size
        @elements.size - 1
    end

    def peek
        @elements[1]
    end

    def print
        @elements
    end

    def sort!
      @elements[1..-1].sort_by! do |el|
        !el ? [0,0] :[1,-el.dist]
      end
    end

    private

    def bubble_up(index)
        parent_i = index / 2
        # Done if you reach top element or parent is already smaller than child
        return if index <= 1 || @elements[parent_i].dist <= @elements[index].dist

        # Otherwise, swap parent & child, then continue bubbling
        @elements[parent_i], @elements[index] = @elements[index], @elements[parent_i]

        bubble_up(parent_i)
    end

    def bubble_down(index)
        child_i = index * 2
        return if child_i > @elements.size - 1

        # get largest child
        not_last = child_i < @elements.size - 1
        left = @elements[child_i]
        right = @elements[child_i + 1]
        child_i += 1 if not_last && right.dist < left.dist

        # stop if parent element is already less than children
        return if @elements[index].dist <= @elements[child_i].dist

        # otherwise, swap and continue
        @elements[index], @elements[child_i] = @elements[child_i], @elements[index]
        bubble_down(child_i)
    end
end