class Day18 < Day
  # data is [], graph is {k => []}, f is {k => 0}, h is {}, result,r,c,x,y are ints
  class Node
    attr_accessor :l, :r, :p

    def self.parse(line)
      mode = :l
      root = Node.new
      curr = root
      line.chars[1..-2].each_with_index do |c,i|
        if c == "["
          node = Node.new(p: curr)
          curr[mode] = node #assign to l or r
          curr = node
          mode = :l
        elsif c[/\d/]
          curr[mode] = c
        elsif c == ","
          mode = :r
        elsif c == "]"
          curr = curr[:p]
        end
      end
      root
    end

    def initialize(l: nil, r: nil, p: nil)
      self.l = l
      self.r = r
      self.p = p
    end

    def to_s
      "[#{l.to_s},#{r.to_s}]"
    end
    def inspect
      to_s
    end
    def +(o)
      Node.new(l: self, r: o).tap do |n|
        self.p = n
        o.p = n
      end
    end

    def mag
      raise unless l && r
      3*(l.is_a?(Node) ? l.mag : l) + 2*(r.is_a?(Node) ? r.mag : r)
    end

    def [](k)
      return l if k == :l
      return r if k == :r
      return p if k == :p
    end

    def []=(k,v)
      self.l = v.is_a?(String) ? v.to_i : v if k == :l
      self.r = v.is_a?(String) ? v.to_i : v if k == :r
      self.p = v if k == :p
    end

    def puts(msg)
      Kernel.puts "L=#{level}#{"  " * (level+1)}##{object_id} #{msg} #{to_s}"
    end

    def level
      p ? p.level + 1 : 0
    end

    def root?
      !p
    end

    def root
      p&.root || self
    end

    def reduce!
      raise "cannot repeat reduce from level #{level}" unless root?
      iter = 0
      # puts "REDUCE START"
      cont = true
      while cont
        # Kernel.puts
        # puts "iters=#{iter}"
        cont = reduce
        iter += 1
      end

      # puts "REDUCE END"
    end

    def explode
      exploded = false
      if level == 4
        # Exploding pairs will always consist of two regular numbers.
        unless l.is_a?(Numeric) && r.is_a?(Numeric)
          raise "not numeric #{to_s}"
        end
        # If any pair is *nested inside four pairs*, the leftmost such pair *explodes*.
        #To *explode* a pair, the pair's left value is added to the first regular number to the left of the exploding pair (if any),
        # puts "EXPLODE BEFORE #{root.to_s}"
        p&.addleft(l,self)
        p&.addright(r,self)
        if self == p&.l
          p.l = 0
        elsif self == p&.r
          p.r = 0
        else
          raise "#{object_id} child is not L or R of parent"
        end
        # puts "EXPLODE AFTER  #{root.to_s}"
        exploded = true # exploding nodes never need further reducing but they did reduce to tell their caller
      else
        exploded = l.is_a?(Node) ? l.explode : false
        exploded ||= r.is_a?(Node) ? r.explode : false
      end
      exploded
    end
    def reduce
      if explode
        # STDERR.puts("after explode:  #{to_s}") if root?
        return true
      elsif split
        # STDERR.puts("after split:    #{to_s}") if root?
        return true
      end
      false
    end

    def split
      # puts "START SPLIT" if root?

      if l.is_a?(Node)
        # print "RECURSE L"
        cont = l.split
        # puts "RECURSE L RESULT=#{cont}"
        return cont if cont
      end
      if l.is_a?(Numeric) && l >= 10
        # If any regular number is *10 or greater*, the leftmost such regular number *splits*.
        self.l = Node.new(l: (l/2.0).floor, r: (l/2.0).ceil, p: self)
        # puts "LSPLIT"
        # puts "SPLIT LEFT AFTER  #{root.to_s}"
        return true
      end
      if r.is_a?(Node)
        # puts "RECURSE R"
        cont = r.split
        # puts "RECURSE R RESULT=#{cont}"
        return cont if cont
      end
      if r.is_a?(Numeric) && r >= 10
        self.r = Node.new(l: (r/2.0).floor, r: (r/2.0).ceil, p: self)
        # puts "RSPLIT"
        return true
      end
      # puts "END REDUCE" if root?

      false
    end

    def addleft(v,from)
      if l.is_a?(Numeric)
        self.l += v
        # puts "addleft(#{v}) FOUND #{root.to_s}"
      elsif l.is_a?(Node) && from == p
        # puts "addleft(#{v}) => l.addleft(#{v})"
        l.addleft(v, self)
      elsif l.is_a?(Node) && l != from
        # puts "addleft(#{v}) => l.addright(#{v})"
        l.addright(v, self)
      elsif p
        # puts "addleft(#{v}) => p.addleft(#{v})"
        p.addleft(v, self)
      else
        # byebug
        # raise "addleft FAIL #{v}"
        # puts "addleft FAIL v=#{v}"
      end
    end

    def addright(v,from)
      if r.is_a?(Numeric)
        self.r += v
        # puts "addright(#{v}) FOUND #{root.to_s}"
      elsif r.is_a?(Node) && from == p
        # puts "addright(#{v}) => addright(#{v})"
        r.addright(v, self)
      elsif r.is_a?(Node) && r != from
        # puts "addright(#{v}) => addleft(#{v}) DESC"
        r.addleft(v, self)
      elsif p
        # puts "addright BUBBLE v=#{v}"
        p.addright(v, self)
      else
        # byebug
        # raise "addright FAIL #{v}"
      end
    end
  end


  def part1
    # debug!
    #
    # v1, v2 = *input.split("\n\n")
    last = nil
    max_mag = 0
    each_line do |line, li|
      node = Node.parse(line)
      abort("#{li} #{line} != #{node.to_s}") unless line == node.to_s
      lines[li+1..-1].each do |line2|
        s = Node.parse(line) + Node.parse(line2)
        s.reduce!
        if s.mag > max_mag
          max_mag = s.mag
        end

        s = Node.parse(line2) + Node.parse(line)
        s.reduce!
        if s.mag > max_mag
          max_mag = s.mag
        end
      end

      if !last
        last = node
      else
        last = (last+node)
        last.reduce!
        if last.mag > max_mag
          max_mag = last.mag
        end
      end
    end
    puts "p1: #{last.mag}"
    puts "p2: #{max_mag}"
    last.mag
    # P1 3012 too low, 4126 too low 5000 too high... 4289 is right.

    # P2 4665 too low.
  end
end
=begin
## --- Day 18: Snailfish ---You descend into the ocean trench and encounter some [snailfish](https://en.wikipedia.org/wiki/Snailfish ""). They say they saw the sleigh keys! They'll even tell you which direction the keys went if you help one of the smaller snailfish with his *math homework*.

Snailfish numbers aren't like regular numbers. Instead, every snailfish number is a *pair* - an ordered list of two elements. Each element of the pair can be either a regular number or another pair.

Pairs are written as `[x,y]`, where `x` and `y` are the elements within the pair. Here are some example snailfish numbers, one snailfish number per line:

```
[1,2]
[[1,2],3]
[9,[8,7]]
[[1,9],[8,5]]
[[[[1,2],[3,4]],[[5,6],[7,8]]],9]
[[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]
[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]
```

This snailfish homework is about *addition*. To add two snailfish numbers, form a pair from the left and right parameters of the addition operator. For example, `[1,2]` + `[[3,4],5]` becomes `[[1,2],[[3,4],5]]`.

There's only one problem: *snailfish numbers must always be reduced*, and the process of adding two snailfish numbers can result in snailfish numbers that need to be reduced.

To *reduce a snailfish number*, you must repeatedly do the first action in this list that applies to the snailfish number:

* If any pair is *nested inside four pairs*, the leftmost such pair *explodes*.
* If any regular number is *10 or greater*, the leftmost such regular number *splits*.

Once no action in the above list applies, the snailfish number is reduced.

During reduction, at most one action applies, after which the process returns to the top of the list of actions. For example, if *split* produces a pair that meets the *explode* criteria, that pair *explodes* before other *splits* occur.

To *explode* a pair, the pair's left value is added to the first regular number to the left of the exploding pair (if any), and the pair's right value is added to the first regular number to the right of the exploding pair (if any). Exploding pairs will always consist of two regular numbers. Then, the entire exploding pair is replaced with the regular number `0`.

Here are some examples of a single explode action:

* `[[[[*[9,8]*,1],2],3],4]` becomes `[[[[*0*,*9*],2],3],4]` (the `9` has no regular number to its left, so it is not added to any regular number).
* `[7,[6,[5,[4,*[3,2]*]]]]` becomes `[7,[6,[5,[*7*,*0*]]]]` (the `2` has no regular number to its right, and so it is not added to any regular number).
* `[[6,[5,[4,*[3,2]*]]],1]` becomes `[[6,[5,[*7*,*0*]]],*3*]`.
* `[[3,[2,[1,*[7,3]*]]],[6,[5,[4,[3,2]]]]]` becomes `[[3,[2,[*8*,*0*]]],[*9*,[5,[4,[3,2]]]]]` (the pair `[3,2]` is unaffected because the pair `[7,3]` is further to the left; `[3,2]` would explode on the next action).
* `[[3,[2,[8,0]]],[9,[5,[4,*[3,2]*]]]]` becomes `[[3,[2,[8,0]]],[9,[5,[*7*,*0*]]]]`.

To *split* a regular number, replace it with a pair; the left element of the pair should be the regular number divided by two and rounded *down*, while the right element of the pair should be the regular number divided by two and rounded *up*. For example, `10` becomes `[5,5]`, `11` becomes `[5,6]`, `12` becomes `[6,6]`, and so on.

Here is the process of finding the reduced result of `[[[[4,3],4],4],[7,[[8,4],9]]]` + `[1,1]`:

```
after addition: [[[[*[4,3]*,4],4],[7,[[8,4],9]]],[1,1]]
after explode:  [[[[0,7],4],[7,[*[8,4]*,9]]],[1,1]]
after explode:  [[[[0,7],4],[*15*,[0,13]]],[1,1]]
after split:    [[[[0,7],4],[[7,8],[0,*13*]]],[1,1]]
after split:    [[[[0,7],4],[[7,8],[0,*[6,7]*]]],[1,1]]
after explode:  [[[[0,7],4],[[7,8],[6,0]]],[8,1]]
```

Once no reduce actions apply, the snailfish number that remains is the actual result of the addition operation: `[[[[0,7],4],[[7,8],[6,0]]],[8,1]]`.

The homework assignment involves adding up a *list of snailfish numbers* (your puzzle input). The snailfish numbers are each listed on a separate line. Add the first snailfish number and the second, then add that result and the third, then add that result and the fourth, and so on until all numbers in the list have been used once.

For example, the final sum of this list is `[[[[1,1],[2,2]],[3,3]],[4,4]]`:

```
[1,1]
[2,2]
[3,3]
[4,4]
```

The final sum of this list is `[[[[3,0],[5,3]],[4,4]],[5,5]]`:

```
[1,1]
[2,2]
[3,3]
[4,4]
[5,5]
```

The final sum of this list is `[[[[5,0],[7,4]],[5,5]],[6,6]]`:

```
[1,1]
[2,2]
[3,3]
[4,4]
[5,5]
[6,6]
```

Here's a slightly larger example:

```
[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]
```

The final sum `[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]` is found after adding up the above snailfish numbers:

```
  [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
+ [7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
= [[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]

  [[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]
+ [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
= [[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]

  [[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]
+ [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
= [[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]

  [[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]
+ [7,[5,[[3,8],[1,4]]]]
= [[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]

  [[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]
+ [[2,[2,2]],[8,[8,1]]]
= [[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]

  [[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]
+ [2,9]
= [[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]

  [[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]
+ [1,[[[9,3],9],[[9,0],[0,7]]]]
= [[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]

  [[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]
+ [[[5,[7,4]],7],1]
= [[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]

  [[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]
+ [[[[4,2],2],6],[8,7]]
= [[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]
```

To check whether it's the right answer, the snailfish teacher only checks the *magnitude* of the final sum. The magnitude of a pair is 3 times the magnitude of its left element plus 2 times the magnitude of its right element. The magnitude of a regular number is just that number.

For example, the magnitude of `[9,1]` is `3*9 + 2*1 = *29*`; the magnitude of `[1,9]` is `3*1 + 2*9 = *21*`. Magnitude calculations are recursive: the magnitude of `[[9,1],[1,9]]` is `3*29 + 2*21 = *129*`.

Here are a few more magnitude examples:

* `[[1,2],[[3,4],5]]` becomes `*143*`.
* `[[[[0,7],4],[[7,8],[6,0]]],[8,1]]` becomes `*1384*`.
* `[[[[1,1],[2,2]],[3,3]],[4,4]]` becomes `*445*`.
* `[[[[3,0],[5,3]],[4,4]],[5,5]]` becomes `*791*`.
* `[[[[5,0],[7,4]],[5,5]],[6,6]]` becomes `*1137*`.
* `[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]` becomes `*3488*`.

So, given this example homework assignment:

```
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
```

The final sum is:

```
[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]```

The magnitude of this final sum is `*4140*`.

Add up all of the snailfish numbers from the homework assignment in the order they appear. *What is the magnitude of the final sum?*
=end
