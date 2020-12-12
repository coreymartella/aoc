require_relative './common'
class P11
  attr_reader :seats, :next_seats
  def initialize
    @seats = []
    File.readlines("data/p11.txt").each_with_index do |line,r|
      seats[r] ||= []
      line.strip.chars.each_with_index do |seat,c|
        seats[r][c] = seat.tr(OLD_EMPTY,EMPTY).tr(OLD_OCC,OCC).tr(OLD_FLOOR,FLOOR)
      end
    end
  end
  OLD_OCC = "#"
  OLD_EMPTY = "L"
  OLD_FLOOR = "."
  OCC = "█"
  EMPTY = "░"
  FLOOR = " "
  def run
    @next_seats = []
    iters = 0
    while true
      clear_lines(seats.size+1) if iters > 0
      puts "iters=#{iters}"
      puts seats.map{|r| r.join}.join("\n")
      seats.each_with_index do |row,r|
        next_seats[r] ||= []
        row.each_with_index do |seat,c|
          count = count_vis_occ(r,c)
          # If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
          if seat == EMPTY && count == 0
            # puts "#{r},#{c} count=#{count} change EMPTY to OCC" if iters == 0
            next_seats[r][c] = OCC
          # If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
          elsif seat == OCC && count > 4
            # puts "#{r},#{c} count=#{count} change OCC to EMPTY" if iters == 0
            next_seats[r][c] = EMPTY
          else
          # Otherwise, the seat's state does not change.
            # puts "#{r},#{c} count=#{count} unchanged =#{seat}" if iters == 0
            next_seats[r][c] = seat
          end
        end
      end
      # puts "next:"
      # puts next_seats.map(&:join).join("\n")
      if next_seats.flatten.join == seats.flatten.join
        break
      end
      iters += 1

      @seats = next_seats.deep_dup
      @next_seats = []
    end
    occ_count = seats.flatten.count{|seat| seat == OCC}
    puts "stabilized iters=#{iters} occ=#{occ_count}"
  end

  def count_adjacent(r,c)
    count = Hash.new(0)
    [-1,0,1].each do |d_r|
      [-1,0,1].each do |d_c|
        adj_r = r+d_r
        adj_c = c+d_c
        next if adj_r < 0 || adj_r >= seats.size || adj_c < 0 || adj_c >= seats.first.size
        next if (adj_r == r && adj_c == c)
        count += 1 if seats[adj_r][adj_c] == OCC
      end
    end
    count
  end

  def count_vis_occ(r,c)
    count = 0
    offsets.each do |d_r,d_c|
      1.upto([seats.size,next_seats.first.size].max) do |step|
        adj_r = r+d_r*step
        adj_c = c+d_c*step
        break if adj_r < 0 || adj_r >= seats.size || adj_c < 0 || adj_c >= seats.first.size
        if seats[adj_r][adj_c] == OCC
          count+= 1
          break
        elsif seats[adj_r][adj_c] == EMPTY
          break
        end
      end
    end
    count
  end

  def offsets
    @offsets ||= begin
      offsets = []
      [-1,0,1].each do |d_r|
        [-1,0,1].each do |d_c|
          next if (d_r == 0 && d_c == 0)
          offsets << [d_r,d_c]
        end
      end
      offsets
    end
  end
end