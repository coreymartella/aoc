require 'bundler'
Bundler.require
require 'pp'
require 'singleton'

UL ||= "\x1B[A"
KL ||= "\x1B[K"
def clear_lines(n=1)
  n.times{print "#{UL}#{KL}";STDOUT.flush}
end
class Array
  def histogram
    group_by(&:itself).map { |k, v| [k, v.size] }.to_h
  end
end


def try_p(num,*args)
  load("p%02d.rb" % num)
  t = Time.now
  res = eval(("::P%02d.instance.run" % num),*args)
  IO.popen('pbcopy', 'r+') { |clipboard| clipboard.print res }
  puts("P#{num}: #{res} in %2.6fs (copied to clipboard)" % (Time.now - t))
  res
end
def setup_p(num)
  File.open("p%02d.rb" % num,'w') do |f|
    f.puts <<-RUBY
load 'common.rb'
class P#{'%02d' % num}
  include Singleton
  attr_reader :lines
  def number
    #{num}
  end
  def run

    lines = File.readlines("data/p%02.txt" % number)

    lines.each_with_index do |line,i|
    end
  end
end
RUBY
  end unless File.exists?("p%03d.rb" % num)
end
