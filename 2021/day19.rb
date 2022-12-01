class Scanner
  attr_accessor :beacons, :id, :fixed, :exhausted, :overlaps, :x, :y, :z
  alias_method :fixed?, :fixed
  def initialize(id:)
    @id = id
    @x = @y = @z = 0
    @beacons ||= []
  end
  def add_beacon(b)
    @beacons << b
    b.id = @beacons.index(b)
  end
  def transform(t)
    raise "transforming fixed" if fixed?
    beacons.each{|b| b.transform(t)}
  end
  def overlap?(other)
    raise "using unfixed scanner #{id}" unless fixed
    vs = vectors
    (0..47).each do |tn|
      other.transform(tn)
      v_matches = other.beacons.product(beacons).each_with_object(Hash.new(0)) do |(ob, b), h|
        v = b - ob
        h[v] += 1
      end
      counts = v_matches.invert
      offset = counts[12]
      next unless offset

      offset = offset.dup
      offset[0] += x
      offset[1] += y
      offset[2] += z
      other.fix_at(*offset)
      puts "scanner #{other.id} must be at #{offset} (relative to scanner #{id})"
      # if (other.beacons.map(&:abs) & beacons.map(&:abs)).size < 12
      #   byebug
      #   raise "offset #{offset} didn't correct, expected >=12 got #{(other.beacons.map(&:abs) & beacons.map(&:abs)).size}"
      # end
      return true

    end
    return false
  end
  def vectors
    @beacons.permutation(2).each_with_object({}) do |(b,b2),h|
      v = b-b2
      raise "vector #{b2}->#{b} duplicated" if h[v]
      h[v] = [b2, b]
    end
  end
  def fix_at(x,y,z=0)
    @fixed = true
    @x = x
    @y = y
    @z = z
    @beacons.each do |b|
      b.offset(x,y,z)
    end
  end
  def unfixed?
    !fixed?
  end
end

class Beacon
  attr_accessor :id, :x, :y, :z
  attr_accessor :x_off, :y_off, :z_off, :tn
  def initialize(x,y,z=0)
    @x_off = @y_off = @z_off = 0
    @x0 = @x = x
    @y0 = @y = y
    @z0 = @z = z
  end

  def transform(tn)
    @transforms ||= {}
    @transforms[tn] ||= begin
      ret = [@x0, @y0, @z0]
      ret[0] *= -1 if tn % 2 == 0
      ret[1] *= -1 if (tn/2) % 2 == 0
      ret[2] *= -1 if (tn/4) % 2 == 0
      p = [[0, 1, 2], [0, 2, 1], [1, 0, 2], [1, 2, 0], [2, 0, 1], [2, 1, 0]][tn/8]
      [ret[p[0]], ret[p[1]], ret[p[2]]]
    end
    @x, @y, @z = *@transforms[tn]
  end

  def -(o)
    [x - o.x, y - o.y, z - o.z]
  end
  def offset(x_off,y_off,z_off)
    @x_off = x_off
    @y_off = y_off
    @z_off = z_off
  end
  def abs
    [x + @x_off, y + @y_off, z + @z_off]
  end
  def to_s
    "[#{x},#{y},#{z}]"
  end
  alias_method :inspect, :to_s

  private
  def ov
    @ov||=Geo3d::Vector.point(@x0,@y0,@z0)
  end
  def v0
    [@x0,@y0,@z0]
  end

  def transformations
    # @transformations ||= [0,Math::PI/2,Math::PI,3*Math::PI/2].flat_map do |rad|
    #   vx = (Geo3d::Matrix.rotation_x(rad)*ov).to_a[0..-2].map(&:round)
    #   vxr = vx.dup.tap{|a| a[0] = -a[0]}
    #   vy = (Geo3d::Matrix.rotation_y(rad)*ov).to_a[0..-2].map(&:round)
    #   vyr = vy.dup.tap{|a| a[1] = -a[1]}
    #   vz = (Geo3d::Matrix.rotation_z(rad)*ov).to_a[0..-2].map(&:round)
    #   vzr = vz.dup.tap{|a| a[2] = -a[2]}
    #   [vx,vy,vz,vxr,vyr,vzr]
    # end
  end
end

class Day19 < Day
  # data is [], graph is {k => []}, f is {k => 0}, h is {}, result,r,c,x,y are ints
  def part1
    # debug!
    #
    # v1, v2 = *input.split("\n\n")
    scanners = []
    input.split("\n\n").each_with_index do |scanner_input,id|
      scanners << (scanner = Scanner.new(id: id))
      scanner_input.lines[1..-1].each do |line|
        scanner.add_beacon(Beacon.new(*eval("[#{line.strip}]")))
      end
    end

    scanners.first.fixed = true
    tried = {}
    while true
      fixed,unfixed = scanners.partition(&:fixed?)
      break if unfixed.none?
      puts("FIXED=%s UNFIXED=%s" % [fixed.map(&:id).sort.join(","), unfixed.map(&:id).sort.join(",")])
      overlap = false
      fixed.reject(&:exhausted).each do |s1|
        unfixed.each do |s2|
          next if tried[[s1.id,s2.id]]

          overlap = s1.overlap?(s2)
          if overlap
            puts "  OVERLAP! #{s1.id} and #{s2.id}"
            break
          else
            tried[[s1.id,s2.id]] = true
          end
        end
        if overlap
          break
        else
          s1.exhausted = true
        end
      end

      if !overlap
        raise "no overlap found!"
      end
    end

    scanners.each do |s|
      s.beacons.each do |b|
        h[b.abs] += 1
      end
    end

    puts "p1=#{h.size}"
    max_man = 0
    scanners.combination(2).each do |s1, s2|
      man = (s1.x - s2.x).abs + (s1.y - s2.y).abs + (s1.z - s2.z).abs
      if man > max_man
        max_man = man
      end
    end

    puts "p2=#{max_man}"
  end

  # def part2
  #   # debug!
  # end
end
