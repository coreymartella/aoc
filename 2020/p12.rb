require_relative './common'
class P12
  attr_reader :data, :dir, :wx, :wy, :sx, :sy
  def initialize
    @dir = E
    @sx = @sy = 0
    @wx = 10
    @wy = 1
    @data = File.readlines("data/p12.txt").map do |l|
      l.strip!
      ins,count = l.scan(/(.)(\d+)/).first
      puts "l=#{l} ins=#{ins} count=#{count}"
      [ins,count.to_i]
    end
  end
  N = 0
  E = 1
  S = 2
  W = 3
  DIRS = {
    N => "N",
    E => "E",
    S => "S",
    W => "W",
  }
  def run
    @data.each do |ins,count|

      print "ins=#{ins} count=#{count} sx=#{sx} sy=#{sy} wx=#{wx} wy=#{wy} "
      if ins == "F"
        @sx += @wx*count
        @sy += @wy*count
      elsif ins == "N" #means to move north by the given value.
        @wy += count
      elsif ins == "S" #means to move south by the given value.
        @wy -= count
      elsif ins == "E" #means to move east by the given value.
        @wx += count
      elsif ins == "W" #means to move west by the given value.
        @wx -= count
      elsif ins == "L" #means to turn left the given number of degrees.
        ox = wx
        oy = wy
        rads = count * Math::PI / 180
        @wx = ox * Math.cos(rads).round - oy * Math.sin(rads).round
        @wy = ox * Math.sin(rads).round + oy * Math.cos(rads).round
      elsif ins == "R" #means to turn right the given number of degrees.
        ox = wx
        oy = wy
        rads = count * Math::PI / 180
        @wx = ox * Math.cos(-rads).round - oy * Math.sin(-rads).round
        @wy = ox * Math.sin(-rads).round + oy * Math.cos(-rads).round
      end
      puts "NOW sx=#{sx} sy=#{sy} wx=#{wx} wsy=#{wy} "
    end
    dist = sx.abs + sy.abs
    puts "finished at sx=#{sx} sy=#{sy} wx=#{wx} wy=#{wy} dist=#{dist}"
  end
end