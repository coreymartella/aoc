class Year2016::P07
  def run
    input = File.read($ARGV[0] || "p08.txt").split("\n")
    w,h = ($ARGV[1] || 50).to_i, ($ARGV[2] || 6).to_i
    screen = Array.new(h){Array.new(w)}
    input.each_with_index do |line,i|
      if line =~ /rect (\d+)x(\d+)/
        w = $1.to_i
        h = $2.to_i
        0.upto(h-1) do |y|
          0.upto(w-1) do |x|
            screen[y][x] = true
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
        clear_lines(screen.size)
      end
      puts screen.map{|r| r.map{|c| c.present? ? "\u2588" : ' '}.join}.join("\n")
    end
  end
end