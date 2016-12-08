require './common'
input = File.read($ARGV[0] || "p08.txt").split("\n")
w,h = ($ARGV[1] || 50).to_i, ($ARGV[2] || 6).to_i
screen = Array.new(h){Array.new(w,'.')}
UL = "\x1B[A"
KL = "\x1B[K"
input.each_with_index do |line,i|
  if line =~ /rect (\d+)x(\d+)/
    w = $1.to_i
    h = $2.to_i
    0.upto(h-1) do |y|
      0.upto(w-1) do |x|
        screen[y][x] = '#'
      end
    end
  elsif line =~ /rotate column x=(\d+) by (\d+)/
    x = $1.to_i
    count = $2.to_i
    new_col = screen.map{|row| row[x]}.rotate(-count)
    new_col.each_with_index do |pix,y|
      screen[y][x] = pix
    end
  elsif line =~ /rotate row y=(\d+) by (\d+)/
    y = $1.to_i
    count = $2.to_i
    new_col = screen[y].rotate(-count)
    screen[y] = new_col
  else
    raise "UNKNOWN #{line}"
  end
  if i != 0
    sleep 0.05
    screen.size.times{print "#{UL}#{KL}";STDOUT.flush}
  end
  puts screen.map(&:join).join("\n")
end
