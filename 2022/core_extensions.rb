class Array
  def histogram
    group_by(&:itself).map { |k, v| [k, v.size] }.to_h
  end
  def average
    sum.to_d/size
  end
  def p50
    sort[size/2.0]
  end
  def p(n)
    pos = n.to_d/size
    sort!
    self[pos]
  end
end

class Range
  def intersection(other)
    raise ArgumentError, 'value must be a Range' unless other.kind_of?(Range)

    new_min = self.cover?(other.min) ? other.min : other.cover?(min) ? min : nil
    new_max = self.cover?(other.max) ? other.max : other.cover?(max) ? max : nil

    new_min && new_max ? new_min..new_max : nil
  end
  alias_method :&, :intersection

  def union(other)
    raise ArgumentError, 'value must be a Range' unless other.kind_of?(Range)
    raise ArgumentError, 'value must overlap' unless other.overlaps?(self)

    new_min = [self.min, other.min].min
    new_max = [self.max, other.max].max
    (new_min..new_max)
  end
  alias_method :|, :union
end

class Integer
  def fact
    (2..self).reduce(1,:*)
  end
end

class Point
  attr_accessor :x, :y
  def initialize(x,y)
    @x = x
    @y = y
  end
  def to_s
    "(#{x},#{y})"
  end
  def inspect
    to_s
  end
  def dist(other)
    Math.sqrt((other.y-y)**2 + (other.x-x)**2)
  end
  def man_dist(other)
    (other.y-y).abs + (other.x-x).abs
  end
end