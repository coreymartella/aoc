class Day17 < Day
  # data is [], graph is {k => []}, f is {k => 0}, h is {}, result,r,c,x,y are ints
  def part1
    # debug!
    #
    tx1, tx2,ty1,ty2 = *input.scan(/target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/).flatten.map(&:to_i)
    tx = tx1 < tx2 ? (tx1..tx2) : (tx2..tx1)
    ty = ty1 < ty2 ? (ty1..ty2) : (ty2..ty1)
    g_ymax = 0
    xv_min = 1
    xv_max = tx.max
    yv_min = [ty.min,ty.max,-ty.min,-ty.max].min
    yv_max = [ty.min,ty.max,-ty.min,-ty.max].min
    hits = 0
    (xv_min..xv_max).each do |sxv|
    # [6].each do |sxv|
      #try with xv
      (yv_min..yv_max).each do |syv|
      # [9,10].each do |syv|
        x=y=ymax=0
        xv=sxv
        yv=syv
        hit = false
        1000.times do |s|
          printf "\r%3d sxv=%3d syv=%3d x=%3d y=%3d xv=%3d yv=%3d hit=%-5s", s,sxv,syv,x,y,xv,yv,hit
          # puts{sprintf "\r%3d sxv=%3d syv=%3d x=%3d y=%3d xv=%3d yv=%3d hit=%-5s", s,sxv,syv,x,y,xv,yv,hit}
          # * The probe's `x` position increases by its `x` velocity.
          x += xv
          # * The probe's `y` position increases by its `y` velocity.
          y += yv
          # * Due to drag, the probe's `x` velocity changes by `1` toward the value `0`;
          xv += (0 <=> xv)
          # * Due to gravity, the probe's `y` velocity decreases by `1`.
          yv -= 1
          if y > ymax
            ymax = y
          end
          hit ||= (tx.include?(x) && ty.include?(y))
          if hit && yv < 0 #if we're falling we've hit our ymax
            # puts! "\n       breaking due to hit and yv=#{yv}"
            break
          elsif yv < 0 && y < tymin # we're only going down from here
            # puts! "\n       breaking due yv=#{yv} y=#{y} vs ymin=#{ymin}"
            break
          elsif !hit && xv <= 0 && x < txmin
            # puts! "\n       breaking due xv=#{xv} x=#{x} vs xmin=#{xmin}"
            break
          elsif !hit && xv >= 0 && x > txmax
            # puts! "\n       breaking due xv=#{xv} x=#{x} vs xmax=#{xmax}"
            break
          end
        end
        hits += 1 if hit
        if hit && ymax > g_ymax
          puts! "  !!! new gymax=#{ymax} via xv=#{sxv} yv=#{syv}"
          g_ymax = ymax
        end
      end
    end
    puts!
    puts!
    # WRONG: 2850,1225, 2775
    puts! "g_ymax=#{g_ymax} hits=#{hits}"

  end

  # def part2
  #   # debug!
  # end
end
=begin
## --- Day 17: Trick Shot ---You finally decode the Elves' message. {:element=>{:name=>"code"@78, :attributes=>[], :children=>[["HI"]], :ignore=>false}}, the message says. You continue searching for the sleigh keys.

Ahead of you is what appears to be a large [ocean trench](https://en.wikipedia.org/wiki/Oceanic_trench ""). Could the keys have fallen into it? You'd better send a probe to investigate.

The probe launcher on your submarine can fire the probe with any [integer](https://en.wikipedia.org/wiki/Integer "") velocity in the `x` (forward) and `y` (upward, or downward if negative) directions. For example, an initial `x,y` velocity like `0,10` would fire the probe straight up, while an initial velocity like `10,-1` would fire the probe forward at a slight downward angle.

The probe's `x,y` position starts at `0,0`. Then, it will follow some trajectory by moving in *steps*. On each step, these changes occur in the following order:

* The probe's `x` position increases by its `x` velocity.
* The probe's `y` position increases by its `y` velocity.
* Due to drag, the probe's `x` velocity changes by `1` toward the value `0`;
  that is, it decreases by `1` if it is greater than `0`, increases by `1` if it is less than `0`, or does not change if it is already `0`.
* Due to gravity, the probe's `y` velocity decreases by `1`.

For the probe to successfully make it into the trench, the probe must be on some trajectory that causes it to be within a *target area* after any step. The submarine computer has already calculated this target area (your puzzle input). For example:

```
target area: x=20..30, y=-10..-5```

This target area means that you need to find initial `x,y` velocity values such that after any step, the probe's `x` position is at least `20` and at most `30`, *and* the probe's `y` position is at least `-10` and at most `-5`.

Given this target area, one initial velocity that causes the probe to be within the target area after any step is `7,2`:

```
.............#....#............
.......#..............#........
...............................
S........................#.....
...............................
...............................
...........................#...
...............................
....................TTTTTTTTTTT
....................TTTTTTTTTTT
....................TTTTTTTT#TT
....................TTTTTTTTTTT
....................TTTTTTTTTTT
....................TTTTTTTTTTT
```

In this diagram, `S` is the probe's initial position, `0,0`. The `x` coordinate increases to the right, and the `y` coordinate increases upward. In the bottom right, positions that are within the target area are shown as `T`. After each step (until the target area is reached), the position of the probe is marked with `#`. (The bottom-right `#` is both a position the probe reaches and a position in the target area.)

Another initial velocity that causes the probe to be within the target area after any step is `6,3`:

```
...............#..#............
...........#........#..........
...............................
......#..............#.........
...............................
...............................
S....................#.........
...............................
...............................
...............................
.....................#.........
....................TTTTTTTTTTT
....................TTTTTTTTTTT
....................TTTTTTTTTTT
....................TTTTTTTTTTT
....................T#TTTTTTTTT
....................TTTTTTTTTTT
```

Another one is `9,0`:

```
S........#.....................
.................#.............
...............................
........................#......
...............................
....................TTTTTTTTTTT
....................TTTTTTTTTT#
....................TTTTTTTTTTT
....................TTTTTTTTTTT
....................TTTTTTTTTTT
....................TTTTTTTTTTT
```

One initial velocity that *doesn't* cause the probe to be within the target area after any step is `17,-4`:

```
S..............................................................
...............................................................
...............................................................
...............................................................
.................#.............................................
....................TTTTTTTTTTT................................
....................TTTTTTTTTTT................................
....................TTTTTTTTTTT................................
....................TTTTTTTTTTT................................
....................TTTTTTTTTTT..#.............................
....................TTTTTTTTTTT................................
...............................................................
...............................................................
...............................................................
...............................................................
................................................#..............
...............................................................
...............................................................
...............................................................
...............................................................
...............................................................
...............................................................
..............................................................#
```

The probe appears to pass through the target area, but is never within it after any step. Instead, it continues down and to the right - only the first few steps are shown.

If you're going to fire a highly scientific probe out of a super cool probe launcher, you might as well do it with *style*. How high can you make the probe go while still reaching the target area?

In the above example, using an initial velocity of `6,9` is the best you can do, causing the probe to reach a maximum `y` position of `*45*`. (Any higher initial `y` velocity causes the probe to overshoot the target area entirely.)

Find the initial velocity that causes the probe to reach the highest `y` position and still eventually be within the target area after any step. *What is the highest `y` position it reaches on this trajectory?*
=end
