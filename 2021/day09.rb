class Day09 < Day
  attr_reader :data, :basin
  def part1
    # debug!
    @data = []
    lines.each_with_index do |line, row|
      data[row] ||= []
      line.strip.chars.each_with_index do |v,col|
        data[row][col] = v.to_i
      end
    end
    pp data
    byebug
    risk = 0
    data.each_with_index do |row,r|
      puts "scanning r=#{r}"
      row.each_with_index do |v,c|
        adj_count = 0
        low_count = 0
        if c > 0
          adj_count += 1
          low_count += 1 if row[c-1] > v
        end
        if c < row.size - 1
          adj_count += 1
          low_count += 1 if row[c+1] > v
        end
        if r > 0
          adj_count += 1
          low_count += 1 if data[r-1][c] > v
        end
        if r < data.size - 1
          adj_count += 1
          low_count += 1 if data[r+1][c] > v
        end
        if adj_count == low_count
          puts! "found low at #{r},#{c}=#{v}"
          risk += (v+1)
        end
      end
    end
    risk
  end

  def part2
    # debug!
    @basin = {}
    @data = []
    lines.each_with_index do |line, row|
      data[row] ||= []
      line.strip.chars.each_with_index do |v,col|
        data[row][col] = v.to_i
      end
    end
    data.each_with_index do |row,r|
      row.each_with_index do |v,c|
        find_basin(r,c)
      end
    end
    basin_sizes = basin.values.histogram
    basin_sizes.values.sort[-3..-1].reduce(:*)

  end

  def find_basin(r,c)
    v = data[r][c]
    return nil if v == 9
    return basin[[r,c]] if basin[[r,c]]

    if c > 0 && data[r][c-1] < v
      return @basin[[r,c]] = find_basin(r,c-1)
    end
    if c < data[r].size - 1 && data[r][c+1] < v
      return @basin[[r,c]] = find_basin(r,c+1)
    end
    if r > 0 && data[r-1][c] < v
      return @basin[[r,c]] = find_basin(r-1,c)
    end
    if r < data.size - 1 && data[r+1][c] < v
      return @basin[[r,c]] = find_basin(r+1,c)
    end
    @basin[[r,c]] = [r,c]
  end
end


=begin
## --- Day 9: Smoke Basin ---These caves seem to be [lava tubes](https://en.wikipedia.org/wiki/Lava_tube ""). Parts are even still volcanically active; small hydrothermal vents release smoke into the caves that slowly settles like rain.

If you can model how the smoke flows through the caves, you might be able to avoid it and be that much safer. The submarine generates a heightmap of the floor of the nearby caves for you (your puzzle input).

Smoke flows to the lowest point of the area it's in. For example, consider the following heightmap:

```
2*1*9994321*0*
3987894921
98*5*6789892
8767896789
989996*5*678
```

Each number corresponds to the height of a particular location, where `9` is the highest and `0` is the lowest a location can be.

Your first goal is to find the *low points* - the locations that are lower than any of its adjacent locations. Most locations have four adjacent locations (up, down, left, and right); locations on the edge or corner of the map have three or two adjacent locations, respectively. (Diagonal locations do not count as adjacent.)

In the above example, there are *four* low points, all highlighted: two are in the first row (a `1` and a `0`), one is in the third row (a `5`), and one is in the bottom row (also a `5`). All other locations on the heightmap have some lower adjacent location, and so are not low points.

The *risk level* of a low point is *1 plus its height*. In the above example, the risk levels of the low points are `2`, `1`, `6`, and `6`. The sum of the risk levels of all low points in the heightmap is therefore `*15*`.

Find all of the low points on your heightmap. *What is the sum of the risk levels of all low points on your heightmap?*
=end
