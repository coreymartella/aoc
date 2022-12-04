require_relative 'setup'
class Day
  C2O = {
    ")" => "(",
    "]" => "[",
    ">" => "<",
    "}" => "{",
  }
  O2C = C2O.invert
  attr_accessor :debug, :data
  attr_accessor :result, :f, :h, :r, :c, :x, :y
  def result
    @result ||= 0
  end
  def r
    @r ||= 0
  end
  def c
    @c ||= 0
  end
  def x
    @x ||= 0
  end
  def x
    @y ||= 0
  end
  def h
    @h ||= Hash.new(0)
  end
  def f
    @f ||= Hash.new(0)
  end
  def graph
    @graph ||= Hash.new{|h,k| h[k] = []}
  end
  def data
    @data ||= []
  end
  def debug!
    @debug = true
  end
  def day
    @day ||= self.class.name.demodulize[/\d+/].to_i
  end
  def sum_adjacent(r,c, diag: false, wrap: false)
    val = 0
    # TL, T, TR,
    val += yield(r-1,c-1) if c > 0 && r > 0 && diag
    val += yield(r-1,c)   if r > 0
    val += yield(r-1,c+1) if c < data[r].size - 1 && r > 0 && diag

    # R, BR, B
    val += yield(r,c+1)   if c < data[r].size - 1
    val += yield(r+1,c+1) if c < data[r].size - 1 && r < data.size - 1 && diag
    val += yield(r+1,c)   if r < data.size - 1

    # BL, L
    val += yield(r+1,c-1) if c > 0 && r < data.size - 1 && diag
    val += yield(r,c-1)   if c > 0

    val
  end
  def each_line
    lines.each_with_index do |line,linenum|
      print "\rL#{'%5d' % (linenum+1)} "
      yield line, linenum
    end
    puts
  end
  def lines
    @lines ||= File.readlines(datafile).map(&:strip)
  end
  def input
    @input ||= File.read(datafile)
  end
  attr_accessor :exfile
  def datafile
    @datafile ||= if ENV["INPUT"] && File.exist?(ENV["INPUT"])
      ENV["INPUT"]
    elsif debug && File.exist?("day#{self.class.name.split("::").last[/\d+/]}.test")
      "day#{self.class.name.split("::").last[/\d+/]}.test"
    else
      "day#{self.class.name.split("::").last[/\d+/]}"
    end
  end
  UL ||= "\x1B[A"
  KL ||= "\x1B[K"
  def clear_lines(n=1)
    n.times{STDOUT.print "#{UL}#{KL}";STDOUT.flush}
  end

  def dprint(msg=nil)
    return unless debug
    msg ||= yield if block_given?
    Kernel.print(msg)
  end
  def print(msg=nil)
    msg ||= yield if block_given?
    Kernel.print(msg)
  end
  def dputs(msg=nil)
    return unless debug
    msg ||= yield if block_given?
    Kernel.puts(msg)
  end
  def puts(msg=nil)
    msg ||= yield if block_given?
    Kernel.puts(msg)
  end

  def aoc_api
    @aoc_api ||= AocApi.new(Time.now.year, ENV['AOC_COOKIE'])
  end

  def answer(part, answer)
    aoc_api.answer(day, part, answer)
  end
end