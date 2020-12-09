Bundler.require
require 'pp'

UL = "\x1B[A"
KL = "\x1B[K"
def clear_lines(n=1)
  n.times{print "#{UL}#{KL}";STDOUT.flush}
end
class Array
  def histogram
    group_by(&:itself).map { |k, v| [k, v.size] }.to_h
  end
end


def try_p(num,*args)
  load("common.rb" % num) 
  load("p%02d.rb" % num) 
  t = Time.now
  res = try("p#{num}",*args)
  IO.popen('pbcopy', 'r+') { |clipboard| clipboard.print res }
  puts("P#{num}: #{res} in %2.6fs (copied to clipboard)" % (Time.now - t)) 
  res
end
def setup_p(num)
  File.open("p%02d.rb" % num,'w') do |f|
    f.puts "load 'common.rb'"
    f.puts "input = File.read(\"p#{'%02d' % num}.txt\")\n"
  end unless File.exists?("p%03d.rb" % num)
end
